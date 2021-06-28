import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.getInstance(context);
    appCubit.getNewTasks();

    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) async {},
      builder: (context, state) {
        return Scaffold(
          body: buildList(
            context: context,
            tasksType: appCubit.newTasks,
            isNew: true,
          ),
        );
      },
    );
  }
}
