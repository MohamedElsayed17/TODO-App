import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/modules/01-tasks_screen/tasks.dart';
import 'package:todo_app/modules/02-done_screen/done.dart';
import 'package:todo_app/modules/03-archive_screen/archive.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:todo_app/shared/network/local/local_database.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(CubitinitialState());

  static AppCubit getInstance(context) => BlocProvider.of(context);

  List<Widget> screens = [
    TasksScreen(),
    DoneScreen(),
    ArchiveScreen(),
  ];
  List<String> screensTitles = [
    'New Tasks',
    'DoneTasks',
    'Archived Tasks',
  ];

  List<Map<String, dynamic>> newTasks = [];
  List doneTasks = [];
  List archivedTasks = [];

  int currentIndex = 0;
  bool isBottomSheetAppear = false;

  void changeBottomSheetState(bool appear) {
    isBottomSheetAppear = appear;
    emit(BottomSheetChangeState());
  }

  void changeBottomNavItem(index) {
    currentIndex = index;
    emit(BottomNavChangeItemState());
  }

  void createDatabase() async {
    await DBLocalHelper.getInstance.database;
    emit(CreateDatebaseState());
    emit(OpenDatebaseState());
  }

  void insertIntoDataabase(Todo todo) async {
    int res = await DBLocalHelper.getInstance.insert(todo);
    if (res == 0)
      print('there is an error into inserting');
    else
      emit(InsertIntoDatebaseState());
  }

  Future<void> getNewTasks() async {
    await DBLocalHelper.getInstance.getTasks(status: 'new').then((value) {
      newTasks = value;
      print(value);
      emit(GetFromDatebaseState());
    });
  }

  Future<void> getDoneTasks() async {
    await DBLocalHelper.getInstance.getTasks(status: 'done').then((value) {
      doneTasks = value;
      print(value);
      emit(GetFromDatebaseState());
    });
  }

  Future<void> getArchivedTasks() async {
    await DBLocalHelper.getInstance.getTasks(status: 'archived').then((value) {
      archivedTasks = value;
      print(value);
      emit(GetFromDatebaseState());
    });
  }

  void deleteItem(int id) async {
    int res = await DBLocalHelper.getInstance.delete(id);
    if (res == 0)
      print('Item not found');
    else
      emit(DeleteFromDatebaseState());
    getNewTasks();
    getDoneTasks();
    getArchivedTasks();
    emit(GetFromDatebaseState());
  }

  Future<void> updateItem(Todo todo) async {
    int res = await DBLocalHelper.getInstance.update(todo);
    if (res == 0)
      print('Item not updated');
    else
      emit(UpdateItemFromDatebaseState());
    print('updated');
    getNewTasks();
    getDoneTasks();
    getArchivedTasks();
    emit(GetFromDatebaseState());
  }

  void clearAllItems() async {
    await DBLocalHelper.getInstance.clearTable();
    emit(ClearDatebaseState());
  }
}
