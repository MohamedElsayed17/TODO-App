import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

// ignore: must_be_immutable
class HomeLayout extends StatelessWidget {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.getInstance(context);
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            titleSpacing: 16.0,
            title: Text('${appCubit.screensTitles[appCubit.currentIndex]}'),
          ),
          body: appCubit.screens[appCubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.add_task),
                label: 'New Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle),
                label: 'done',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.archive),
                label: 'archive',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              print(index);
              appCubit.changeBottomNavItem(index);
            },
            currentIndex: appCubit.currentIndex,
            elevation: 15.0,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _onButtonPressed(context);
            },
            child: AppCubit.getInstance(context).isBottomSheetAppear
                ? Icon(Icons.check)
                : Icon(Icons.edit),
          ),
        );
      },
    );
  }

  void _onButtonPressed(context) {
    if (!AppCubit.getInstance(context).isBottomSheetAppear)
      _scaffoldKey.currentState!
          .showBottomSheet((context) {
            AppCubit.getInstance(context).changeBottomSheetState(true);
            return _buildBottomNavigationMenu(context);
          })
          .closed
          .whenComplete(() {
            AppCubit.getInstance(context).changeBottomSheetState(false);
            String title = titleController.text.toString();
            String time = timeController.text.toString();
            String date = dateController.text.toString();
            if (time.isNotEmpty && title.isNotEmpty && date.isNotEmpty)
              AppCubit.getInstance(context).insertIntoDataabase(Todo(
                title: title,
                time: time,
                date: date,
                status: 'new',
              ));
            AppCubit.getInstance(context).getNewTasks();
          });
    else {
      if (_formKey.currentState!.validate())
        Navigator.pop(context);
      else
        print('error');
    }
  }

  Widget _buildBottomNavigationMenu(context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      height: MediaQuery.of(context).size.height / 2.5,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              buildTextForm(
                hint: 'Title',
                controller: titleController,
                icon: Icons.title,
                validator: (val) {
                  if (val!.isEmpty) return 'Title is Empty';
                  return null;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              buildTextForm(
                hint: 'Time',
                controller: timeController,
                icon: Icons.timelapse,
                onPress: () {
                  _showTimePicker(context);
                },
                readOnly: true,
                validator: (val) {
                  if (val!.isEmpty) return 'Time is Empty';
                  return null;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              buildTextForm(
                hint: 'Date',
                controller: dateController,
                icon: Icons.date_range,
                onPress: () {
                  _showDatePicker(context);
                },
                readOnly: true,
                validator: (val) {
                  if (val!.isEmpty) return 'Date is Empty';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePicker(context) async {
    final TimeOfDay? result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      print(result.format(context));
      timeController.text = result.format(context);
    }
  }

  Future<void> _showDatePicker(context) async {
    final DateTime? result = await showDatePicker(
      context: context,
      firstDate: DateTime(2021),
      initialDate: DateTime.now(),
      lastDate: DateTime(2022),
    );
    if (result != null) {
      print(result.toString());
      dateController.text = result.toString().substring(0, 10);
    }
  }
}
