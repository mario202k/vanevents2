import 'dart:async' show Stream;
import 'package:async/async.dart' show StreamGroup;
import 'package:async/async.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vanevents/models/chat.dart';
import 'package:vanevents/models/message.dart';
import 'package:vanevents/models/user.dart';
import 'package:vanevents/routing/route.gr.dart';
import 'package:vanevents/services/firestore_database.dart';
import 'package:vanevents/shared/topAppBar.dart';

class Chat extends StatefulWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  Chat(this.innerDrawerKey);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  Stream friendUser;
//  List<User> users = List<User>();
//  List<Chat> chats = List<Chat>();

  List<Object> usersAndChats = List<Object>();

  @override
  void dispose() {
    if (friendUser != null) {
      friendUser = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<FirestoreDatabase>(context, listen: false);
    
    friendUser = StreamZip([db.usersStreamChat1(), db.usersStreamChat2(),db.chatRoomGroupe()]);

    print('Chat!!!!!!!');
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: TopAppBar(
              'Chat',
              true,
              () => widget.innerDrawerKey.currentState.toggle(),
              double.infinity),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.background,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight),
                  child: StreamBuilder<List<Object>>(
                    stream: friendUser,
                    //qui ont deja discuter
                    //initialData: [[],[]],
                    builder: (context, snapshot) {
                      print(snapshot.data);

                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Center(
                          child: Text('Erreur de connexion'),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.secondary)),
                        );
                      }

//                      chats.clear();
//                      users.clear();
//                      users.addAll(snapshot.data[0]);
//                      users.addAll(snapshot.data[1]);
//                      chats.addAll(snapshot.data[2]);

                      usersAndChats.clear();


                      return usersAndChats.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) => Divider(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    thickness: 1,
                                  ),
                              itemCount: usersAndChats.length,
                              itemBuilder: (context, index) {
                                User userFriend = User();
                                MyChat chat = MyChat();
                                bool isUser= false;
                                if(usersAndChats.elementAt(index) is User){
                                  userFriend = usersAndChats.elementAt(index);
                                  isUser = true;
                                }else{
                                  chat = usersAndChats.elementAt(index);
                                }

                                Stream<Message> lastMsg = db.getLastChatMessage(

                                    isUser?userFriend.chatId[db.uid]:chat.id);
                                Stream<List<Message>> msgNonLu =
                                    db.getChatMessageNonLu(
                                        isUser?userFriend.chatId[db.uid]:chat.id);

                                return StreamBuilder<Message>(
                                    stream: lastMsg,
                                    builder: (context, snapshot) {
                                      Message message;
                                      String day = '', month = '';
                                      if (!snapshot.hasData) {
                                        message = Message(
                                            message: 'aucun message', type: -1);
                                      } else {
                                        message = snapshot.data;

                                        if (message == null) return ListTile();

                                        day = message.date.day
                                                    .toString()
                                                    .length ==
                                                1
                                            ? '0${message.date.day.toString()}'
                                            : '${message.date.day.toString()}';

                                        month = message.date.month
                                                    .toString()
                                                    .length ==
                                                1
                                            ? '0${message.date.month.toString()}'
                                            : '${message.date.month.toString()}';
                                      }

                                      return ListTile(
                                        title: Text(
                                          isUser?userFriend.nom:chat.titre,
                                          style:
                                              Theme.of(context).textTheme.title,
                                        ),
                                        subtitle: message.type == 0
                                            ? Text(
                                                message.message,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .button,
                                              )
                                            : message.type == 1
                                                ? Row(
                                                    children: <Widget>[
                                                      Icon(FontAwesomeIcons
                                                          .photoVideo),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text('Photo',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .button)
                                                    ],
                                                  )
                                                : message.type == 2
                                                    ? Row(
                                                        children: <Widget>[
                                                          Icon(FontAwesomeIcons
                                                              .photoVideo),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text('gif',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .button)
                                                        ],
                                                      )
                                                    : Text(message.message,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .button),
                                        onTap: () {
                                          isUser?
                                          db
                                              .getChatId(userFriend.id)
                                              .then((chatId) {
                                            db.chatRoom(chatId).then((chat) {
                                              Router.navigator.pushNamed(
                                                  Routes.chatRoom,
                                                  arguments: ChatRoomArguments(
                                                      isGroupe: chat.isGroupe,
                                                      myId: db.uid,
                                                      nomFriend: userFriend.nom,
                                                      imageFriend:
                                                          userFriend.imageUrl,
                                                      chatId: chatId,
                                                      friendId: userFriend.id));
                                            });

//                                          Navigator.of(context).pushNamed(
//                                              Router.chatRoom,
//                                              arguments: ChatRoomArguments(
//                                                  myId: db.uid,
//                                                  nomFriend: userFriend.nom,
//                                                  imageFriend:
//                                                      userFriend.imageUrl,
//                                                  chatId: chatId,
//                                                  friendId: userFriend.id));
//                                      Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                              builder: (context) => ChatRoom(
//                                                  db.uid,
//                                                  userFriend.nom,
//                                                  userFriend.imageUrl,
//                                                  chatId,
//                                                  userFriend.id)));
                                          }) :
                                          Router.navigator.pushNamed(
                                              Routes.chatRoom,
                                              arguments: ChatRoomArguments(
                                                  isGroupe: chat.isGroupe,
                                                  myId: db.uid,
                                                  nomFriend: chat.titre,
                                                  imageFriend:
                                                  chat.imageUrl,
                                                  chatId: chat.id,))
                                          ;
                                        },
                                        leading: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(userFriend.imageUrl),
                                          radius: 25,
                                        ),
                                        trailing: Column(
                                          children: <Widget>[
                                            message.type != -1
                                                ? Text(
                                                    //si c'est aujourh'hui l'heure sinon date
                                                    '${DateTime.now().day != message.date.day ? '$day/$month/${message.date.year}' : '${message.date.hour.toString().length == 1 ? 0 : ''}${message.date.hour}:${message.date.minute.toString().length == 1 ? 0 : ''}${message.date.minute}'}')
                                                : SizedBox(),
                                            StreamBuilder(
                                                stream: msgNonLu,
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return SizedBox();
                                                  }

                                                  int i = 0;

                                                  snapshot.data.documents
                                                      .forEach((doc) {
                                                    i++;
                                                  });

                                                  return i != 0
                                                      ? Badge(
                                                          badgeContent:
                                                              Text('$i'),
                                                          child: Icon(
                                                              Icons.markunread),
                                                        )
                                                      : SizedBox();
                                                }),
                                          ],
                                        ),
                                      );
                                    });
                              })
                          : Center(
                              child: Text(
                                'Pas de conversation',
                                style: Theme.of(context).textTheme.button,
                              ),
                            );
                    },
                  ),
                ),
              );
            },
          ),
        ));
  }
}
