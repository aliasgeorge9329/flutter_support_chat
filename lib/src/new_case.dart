import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model/chat.dart';
import 'model/message.dart';
import 'model/state.dart';
import 'overview.dart';

/// `FlutterSupportChatCreateNewCase` is should only used in FlutterSupportChat.
class FlutterSupportChatCreateNewCase extends StatelessWidget {
  /// `supporterID` is a required list of Ids.
  /// Ids can be Email or FirebaseUsersIds
  /// This Ids are able to view all Cases.
  final List<String> supporterID;

  /// `currentID` is a required ID.
  /// Id can be Email or FirebaseUsersId
  /// Cases are visible based on this ID, comments are made for this id.
  final String currentID;

  /// `onNewCaseText` is a required String.
  /// New Cases will have this message by default.
  /// Message is send by the first supporterID
  final String onNewCaseText;

  /// `createCaseButtonText` is a optional String.
  /// This text is shown on the button to create a new Case
  final String createCaseButtonText;

  /// `selectCase` is should only used in FlutterSupportChat.
  final Function(String) selectCase;

  /// `onNewCaseCreated` is a optional Function.
  /// With this for example you can send a push notification to a supporter
  final Function(SupportChat) onNewCaseCreated;
  final String deviceInfos;

  const FlutterSupportChatCreateNewCase({
    Key? key,
    required this.supporterID,
    required this.currentID,
    required this.onNewCaseText,
    required this.createCaseButtonText,
    required this.selectCase,
    required this.onNewCaseCreated,
    required this.deviceInfos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {
          var result;
          await showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('A short description for the case'),
                content: TextField(
                  onChanged: (value) {
                    result = value;
                  },
                  decoration: InputDecoration(hintText: "Enter title for the issue"),
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      return;
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          if (result == null) {
            return;
          }
          SupportChat chat = SupportChat(
            id: '',
            requester: currentID,
            createTimestamp: Timestamp.now(),
            title: result,
            messages: [
              SupportChatMessage(
                  content: onNewCaseText,
                  sender: supporterID.first,
                  timestamp: Timestamp.now(),
                  deviceInfos: deviceInfos),
            ],
            lastEditTimestmap: Timestamp.now(),
            state: SupportCaseState.waitingForCustomer,
          );
          final DocumentReference d = await support.add(
            chat.toFireStore(),
          );
          chat.id = d.id;

          selectCase(chat.id);
          onNewCaseCreated(chat);
        },
        title: Text(
          createCaseButtonText,
        ),
        leading: Icon(
          Icons.add_comment_outlined,
        ),
        trailing: Icon(
          Icons.adaptive.arrow_forward,
        ),
      ),
    );
  }
}
