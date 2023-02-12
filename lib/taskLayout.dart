
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/component.dart';
import 'package:todo_app/cubit.dart';
import 'package:todo_app/done_screen.dart';
import 'package:todo_app/new_screen.dart';
import 'package:todo_app/state.dart';

class tasklayout extends StatelessWidget {

  bool pressSave = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> AppCubit()..createDatabase(),
      child: BlocConsumer <AppCubit , AppState>(
          listener: (BuildContext context , AppState state){},

          builder: (BuildContext context , AppState state){
            AppCubit cubit =AppCubit.get(context);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Scaffold(
                appBar: AppBar(
                  title : Center(
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            '${cubit.title[cubit.currentIndex]}',
                            style:TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


                body: ConditionalBuilder(
                    condition: state is! AppGetDatabaseLoadingState,
                    builder: (context) => cubit.screens[cubit.currentIndex],
                    fallback: (context) => Center(child: CircularProgressIndicator()),
                ),


                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.blueAccent,
                  onPressed: () {
                     showModalBottomSheet(
                       isScrollControlled: true,
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              child: SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: titleController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        labelText: 'Task title',
                                        icon: Icon( Icons.title),
                                      ),
                                    ),

                                    SizedBox(
                                      height: 10,
                                    ),

                                    TextFormField(
                                      controller: timeController,
                                      keyboardType: TextInputType.text,
                                      onTap: (){
                                        showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now()
                                        ).then((value){
                                          timeController.text = value.format(context).toString();
                                        });
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        labelText:'Task time',
                                        icon: Icon( Icons.access_time_outlined),
                                      ),
                                    ),

                                    SizedBox(
                                      height: 10,
                                    ),

                                    TextFormField(
                                      controller: dateController,
                                      keyboardType: TextInputType.text,
                                      onTap: (){
                                        showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.parse('2030-01-01'),
                                        ).then((value){
                                          dateController.text = DateFormat.yMMMd().format(value);
                                        });
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        labelText:'Task date',
                                        icon: Icon( Icons.date_range),
                                      ),
                                    ),

                                    ElevatedButton(onPressed: (){
                                      cubit.insertToDatabase(
                                          title: titleController.text,
                                          date: dateController.text,
                                          time: timeController.text,
                                      );

                                        // Fluttertoast.showToast(
                                        //   msg: 'successfuly added',
                                        //   backgroundColor: Colors.green,
                                        //   toastLength:Toast.LENGTH_LONG,
                                        //   textColor: Colors.white,
                                        // );

                                        Navigator.pop(context);

                                        },

                                        child: Text('save',
                                          style: GoogleFonts.leckerliOne(fontSize: 30),

                                        ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        );

                      },
                    );
                  },
                  child: Icon(
                    Icons.add,
                  ),
                ),

                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: cubit.currentIndex,
                  selectedItemColor: Colors.blueAccent,
                  onTap: (index){
                    cubit.onItemTapped(index);
                  },

                  items: [

                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.menu,
                      ),
                      label: 'Tasks',
                    ),


                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.check_circle_outline,
                      ),
                      label: 'Done',
                    ),


                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.archive_outlined,
                      ),
                      label: 'Archeive',
                    ),

                  ],
                ),
              ),
            );
          },
      ),
    );
  }
}
