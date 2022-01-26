import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/layout/cubit/cubit.dart';
import 'package:todo_app/layout/cubit/states.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/styles/colors.dart';


class HomeLayout extends StatelessWidget
{

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener:(context, state) {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        } ,
        builder: (context, state){
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: pinkColor,
            key: scaffoldKey,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: pinkColor,
              ),
              elevation: 2.0,
              backgroundColor: pinkColor,
              centerTitle: true,
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: TextStyle(
                  color: blueColor,
                ),
              ),
            ),
            body: ConditionalBuilderRec(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator(color: Colors.teal,)),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: blueColor,
              onPressed: (){
                if(cubit.isBottomSheetShown){
                  if(formKey.currentState.validate())
                  {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                    );
                  }
                }
                else {
                  scaffoldKey.currentState.showBottomSheet(
                          (context) => Container(
                        width:  double.infinity,
                        color: Color(0xffFFE4E3),
                        padding: EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultTextFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  label: 'Title Task',
                                  prefix: Icons.title,
                                  validate: (value){
                                    if (value.isEmpty){
                                      return 'title must not be empty';
                                    }
                                    return null;
                                  }
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              defaultTextFormField(
                                  onTap: ()
                                  {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value){
                                      timeController.text = value.format(context);
                                      print(value.format(context));
                                    });
                                  },
                                  controller: timeController,
                                  type: TextInputType.text,
                                  label: 'Time Task',
                                  prefix:Icons.watch_later_outlined,
                                  validate: (value){
                                    if (value.isEmpty){
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  }
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              defaultTextFormField(
                                  onTap: (){
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse("2022-02-10"),
                                    ).then((value){
                                      dateController.text = DateFormat.yMMMd().format(value);
                                    });
                                  },
                                  controller: dateController,
                                  type: TextInputType.text,
                                  label: 'Date Task',
                                  prefix: Icons.calendar_today,
                                  validate: (value){
                                    if (value.isEmpty){
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  }
                              ),
                            ],
                          ),
                        ),

                      )
                  ).closed.then((value){
                    cubit.changeBottomSheetState(
                      isShow: false,
                      icon: Icons.edit,
                    );
                  });
                  cubit.changeBottomSheetState(
                    isShow: true,
                    icon: Icons.add,
                  );
                }
              },
              child: Icon(
                cubit.fabIcon,
                color: pinkColor,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: blueColor,
              selectedItemColor: pinkColor,
              unselectedItemColor: Color(0xff5D6F93),
              currentIndex: cubit.currentIndex,
              onTap: (index)
              {
                cubit.changeIndex(index);
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
                    Icons.check,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive,
                  ),
                  label: 'Archive',
                ),
              ],
            ),

          );
        },
      ),
    );
  }


}
