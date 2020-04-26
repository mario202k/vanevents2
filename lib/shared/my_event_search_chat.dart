import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vanevents/models/event.dart';

class MyEventSearch extends SearchDelegate<MyEvent> {
  final Bloc<MyEventSearchEvent, MyEventSearchState> myEventBloc;

  MyEventSearch(this.myEventBloc);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: BackButtonIcon(),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    myEventBloc.add(MyEventSearchEvent(query));

    return BlocBuilder(
      bloc: myEventBloc,
      builder: (BuildContext context, MyEventSearchState state) {
        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.secondary)),
          );
        }

        if (state.hasError) {
          return Container(
            child: Text('Error', style: Theme.of(context).textTheme.button),
          );
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            print(index);
            return ListTile(
              title: Text(state.myEvents ?? ''),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(state.myEvents[index].imageUrl),
                radius: 25,
              ),
              onTap: () {
                close(context, state.myEvents[index]);
              },
            );
          },
          itemCount: state.myEvents.length,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.

    myEventBloc.add(MyEventSearchEvent(query));

    return BlocBuilder(
      bloc: myEventBloc,
      builder: (BuildContext context, MyEventSearchState state) {
        if (state.isLoading) {
          return Container(
            color: Theme.of(context).colorScheme.background,
            child: Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.secondary)),
            ),
          );
        }

        if (state.hasError) {
          return Container(
            color: Theme.of(context).colorScheme.background,
            child: Center(
                child:
                Text('Error', style: Theme.of(context).textTheme.button)),
          );
        }

//        int j;
//
//        for (int i = 0; i < state.users.length; i++) {
//          if (state.users[i].id == user.uid) {
//            j = i;
//            break;
//          }
//        }
//
//        if (j != null) state.users.removeAt(j);

        return Container(
          color: Theme.of(context).colorScheme.background,
          child: ListView.builder(
            itemBuilder: (context, index) {
              print(index);
              return ListTile(
                title: Text(
                  state.myEvents[index].titre ?? '',
                  style: Theme.of(context).textTheme.button,
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(state.myEvents[index].imageUrl),
                  radius: 25,
                ),
                onTap: () {
                  close(context, state.myEvents[index]);
                },
              );
            },
            itemCount: state.myEvents.length,
          ),
        );
      },
    );
  }
}

class MyEventBlocSearchName extends Bloc<MyEventSearchEvent, MyEventSearchState> {
  List<MyEvent> myEvents = List<MyEvent>();

  @override
  MyEventSearchState get initialState => MyEventSearchState.initial();

  @override
  void onTransition(Transition<MyEventSearchEvent, MyEventSearchState> transition) {
    print(transition.toString());
  }

  @override
  Stream<MyEventSearchState> mapEventToState(MyEventSearchEvent event) async* {
    yield MyEventSearchState.loading();

    try {
      List<MyEvent> myEvents = await _getSearchResults(event.query);
      yield MyEventSearchState.success(myEvents);
    } catch (err) {
      yield MyEventSearchState.error();
    }
  }

  Future<List<MyEvent>> _getSearchResults(String query) async {
    List<MyEvent> result = List<MyEvent>();

//    Firestore.instance
//        .collection('collection-name')
//        .orderBy('name')
//        .startAt([query])
//        .endAt([query + '\uf8ff']).snapshots()

    if (myEvents.isEmpty) {
//      List<MyEvent> user1 = await Firestore.instance
//          .collection('users')
//          .where('id', isGreaterThan: myId)
//          .getDocuments()
//          .then((docs) => docs.documents
//              .map((doc) => MyEvent.fromMap(doc.data, doc.documentID))
//              .toList());
//      List<MyEvent> user2 = await Firestore.instance
//          .collection('users')
//          .where('id', isLessThan: myId)
//          .getDocuments()
//          .then((docs) => docs.documents
//              .map((doc) => MyEvent.fromMap(doc.data, doc.documentID))
//              .toList());

      myEvents = await Firestore.instance.collection('events').getDocuments().then(
              (docs) => docs.documents
              .map((doc) => MyEvent.fromMap(doc.data, doc.documentID))
              .toList());

      //users = List.from(user1)..addAll(user2); //Tout le monde sauf moi

      result.addAll(myEvents);
    } else {
      myEvents.forEach((myEvent) {
        if (myEvent.titre.contains(query)) {
          result.add(myEvent);
        }
      });
    }
    return result;
  }
}

class MyEventSearchEvent {
  final String query;

  const MyEventSearchEvent(this.query);

  @override
  String toString() => 'MyEventSearchEvent { query: $query }';
}

class MyEventSearchState {
  final bool isLoading;
  final List<MyEvent> myEvents;
  final bool hasError;

  const MyEventSearchState({this.isLoading, this.myEvents, this.hasError});

  factory MyEventSearchState.initial() {
    return MyEventSearchState(
      myEvents: [],
      isLoading: false,
      hasError: false,
    );
  }

  factory MyEventSearchState.loading() {
    return MyEventSearchState(
      myEvents: [],
      isLoading: true,
      hasError: false,
    );
  }

  factory MyEventSearchState.success(List<MyEvent> users) {
    return MyEventSearchState(
      myEvents: users,
      isLoading: false,
      hasError: false,
    );
  }

  factory MyEventSearchState.error() {
    return MyEventSearchState(
      myEvents: [],
      isLoading: false,
      hasError: true,
    );
  }

  @override
  String toString() =>
      'MyEventSearchState {users: ${myEvents.toString()}, isLoading: $isLoading, hasError: $hasError }';
}
