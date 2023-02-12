import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/archived_screen.dart';
import 'package:todo_app/component.dart';
import 'package:todo_app/cubit.dart';
import 'package:todo_app/done_screen.dart';
import 'package:todo_app/new_screen.dart';
import 'package:todo_app/state.dart';

class AppCubit extends Cubit<AppState>{

  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    newScreen(),
    doneScreen(),
    archivedScreen(),
  ];

  List<String>title = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  Database database;
  List<Map>newTasks = [];
  List<Map>doneTasks = [];
  List<Map>archievedTasks = [];

  void onItemTapped(int index) {
      currentIndex = index;
      emit(AppChangeBottomNavBarState());
  }



  void createDatabase(){

    openDatabase(
      'todo.db',
      version:1,
      onCreate:(database , version){
        database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT , status TEXT)'
        ).then((value){
          print('table created');
        }).catchError((error){
          print('error');
        });
      },

      onOpen: (database){
        print('database opened');
        getDataFromDatabase(database);
      },
    ).then((value){
      database = value;
      emit(AppCreateDatabaseState());
    });

  }


  void getDataFromDatabase(database) async {
    newTasks = [];
    doneTasks = [];
    archievedTasks = [];

    emit(AppGetDatabaseLoadingState());

    await database.rawQuery('SELECT * FROM tasks').then((value){
      value.forEach((element){
        if(element['status'] ==  'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archievedTasks.add(element);
      });
    });
    emit(AppGetDatabaseState());
    print('database arrived');
  }

  insertToDatabase({
    @required String title,
    @required String date,
    @required String time,
}) async {
    await database.transaction((txn){
      txn.rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES ("$title" , "$date" , "$time" , "new") ' ,
      ).then((value){
        print('$value done inserted');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
        emit(AppGetDatabaseState());
      }).catchError((error){
        print('error when inserted');
      });
    });
  }
  
  void updateDatabase({
    @required String status,
    @required int id,
}) async {
    await database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ? ',
      ['$status' , id],
    ).then((value){
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteDatabase({
  @required int id,
})async{
    await database.rawDelete(
      'DELETE FROM tasks WHERE id = ?',[id],
    ).then((value){
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

}