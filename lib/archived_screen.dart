
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/component.dart';
import 'package:todo_app/cubit.dart';
import 'package:todo_app/state.dart';

class archivedScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppState>(
      listener: (context , state){},
        builder: (context , state){
        var task = AppCubit.get(context).archievedTasks;
        return taskBuilder(
            tasks: task ,
        );
        },
    );
  }
}
