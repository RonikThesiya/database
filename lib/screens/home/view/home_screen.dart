import 'package:database/screens/home/controller/home_controller.dart';
import 'package:database/screens/home/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());

  TextEditingController txtname = TextEditingController();
  TextEditingController txtstd = TextEditingController();
  TextEditingController txtmobile = TextEditingController();

  TextEditingController txtuname = TextEditingController();
  TextEditingController txtustd = TextEditingController();
  TextEditingController txtumobile = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    DatabaseHelper db = DatabaseHelper();
    homeController.stdList.value = await db.readData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Database"),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: homeController.stdList.value.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text("${homeController.stdList.value[index]['id']}"),
              title: Text("${homeController.stdList.value[index]['name']}"),
              subtitle:
                  Text("${homeController.stdList.value[index]['mobile']}"),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          txtuname = TextEditingController(
                              text:
                                  "${homeController.stdList.value[index]['name']}");
                          txtustd = TextEditingController(
                              text:
                                  "${homeController.stdList.value[index]['std']}");
                          txtumobile = TextEditingController(
                              text:
                                  "${homeController.stdList.value[index]['mobile']}");

                          Get.defaultDialog(
                            content: Column(
                              children: [
                                TextField(
                                  controller: txtuname,
                                  decoration: InputDecoration(hintText: "Name"),
                                ),
                                TextField(
                                  controller: txtustd,
                                  decoration: InputDecoration(hintText: "Std"),
                                ),
                                TextField(
                                  controller: txtumobile,
                                  decoration: InputDecoration(hintText: "Mobile"),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      DatabaseHelper db = DatabaseHelper();
                                      db.updateData("${homeController.stdList.value[index]['id']}",txtuname.text, txtustd.text, txtumobile.text);
                                      getData();
                                    },
                                    child: Text("Update"))
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.edit)),
                    IconButton(onPressed: (){
                      DatabaseHelper db = DatabaseHelper();
                      db.deleteData("${homeController.stdList.value[index]['id']}");
                      getData();
                    }, icon: Icon(Icons.delete)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.defaultDialog(
              content: Column(
            children: [
              TextField(
                controller: txtname,
                decoration: InputDecoration(hintText: "Name"),
              ),
              TextField(
                controller: txtstd,
                decoration: InputDecoration(hintText: "Std"),
              ),
              TextField(
                controller: txtmobile,
                decoration: InputDecoration(hintText: "Mobile"),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    DatabaseHelper db = DatabaseHelper();
                    db.insertData(txtname.text, txtstd.text, txtmobile.text);
                    getData();
                    Get.back();
                  },
                  child: Text("Submit"))
            ],
          ),
          );
        },
      ),
    ));
  }
}
