import 'package:flutter/material.dart';
import 'package:kumuly_pocket/entities/contact_entity.dart';
import 'package:kumuly_pocket/enums/payment_request_type.dart';
import 'package:kumuly_pocket/features/add_contact_flow/add_contact_state.dart';
import 'package:kumuly_pocket/features/contacts/contact_list_controller.dart';
import 'package:kumuly_pocket/features/contacts/frequent_contacts_controller.dart';
import 'package:kumuly_pocket/repositories/lightning_node_repository.dart';
import 'package:kumuly_pocket/services/chat_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_contact_controller.g.dart';

@riverpod
class AddContactController extends _$AddContactController {
  @override
  AddContactState build() {
    final idFocus = FocusNode();
    final idTextController = TextEditingController();
    final nameFocus = FocusNode();

    idFocus.addListener(() {
      if (!idFocus.hasFocus) {
        onIdUnfocusHandler();
      }
    });

    ref.onDispose(() {
      idFocus.dispose();
      idTextController.dispose();
      nameFocus.dispose();
    });

    return AddContactState(
      idFocusNode: idFocus,
      idTextController: idTextController,
      nameFocusNode: nameFocus,
    );
  }

  Future<void> onIdChangeHandler(String id) async {
    state = AddContactState(
      idFocusNode: state.idFocusNode,
      idTextController: state.idTextController,
      nameFocusNode: state.nameFocusNode,
    );

    if (id.isEmpty) {
      return;
    }

    try {
      final parsedPaymentRequest = await ref
          .read(breezeSdkLightningNodeRepositoryProvider)
          .decodePaymentRequest(id);

      if (parsedPaymentRequest.type == PaymentRequestType.nodeId) {
        state = state.copyWith(
          id: id,
          idInputError: null,
        );
        state.idFocusNode.unfocus();
      }
    } catch (e) {
      print('Error parsing payment request: $e');
    }
  }

  Future<void> onIdUnfocusHandler() async {
    if (state.id == null || state.id!.isEmpty) {
      state = state.copyWith(
        idInputError: Error(),
      );
    }
  }

  Future<void> onNameChangeHandler(String name) async {
    // Todo: validate name and set error if not valid
    state = state.copyWith(name: name);
  }

  Future<void> saveContact() async {
    if (state.id == null || state.name == null) {
      // Todo: set and throw error
      throw Error();
    }

    final newContact = ContactEntity(
      name: state.name!,
      avatarImagePath: state.avatarImagePath,
      nodeId: state.id!,
      createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
    final contactId = await ref.read(sqliteChatServiceProvider).addNewContact(
          newContact,
        );

    state = state.copyWith(contactId: contactId);

    // Invalidate contact list and frequent contacts since we added a new contact so the lists need to be refreshed
    ref.invalidate(contactListControllerProvider);
    ref.invalidate(frequentContactsControllerProvider);
  }
}
