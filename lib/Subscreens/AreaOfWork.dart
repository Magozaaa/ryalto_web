// ignore_for_file: use_key_in_widget_constructors, file_names, unnecessary_string_interpolations, prefer_final_fields

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rightnurse/AnalyticsManager/AnalyticsManager.dart';
import 'package:rightnurse/Models/HospitalModel.dart';
import 'package:rightnurse/Models/UserModel.dart';
import 'package:rightnurse/Providers/CallProvider.dart';
import 'package:rightnurse/Providers/UserProvider.dart';
import 'package:rightnurse/Widgets/commonWidgets.dart';

class AreaOfWork extends StatefulWidget{

  static const String routeName = "/AreaOfWork_Screen";

  @override
  _AreaOfWorkState createState() => _AreaOfWorkState();
}

class _AreaOfWorkState extends State<AreaOfWork> {

  List<List> isSelected = [];
  List isChildSelected = [];
  Map<String,dynamic> selected ={};
  List<bool> selectAll = [];

  Map passedData = {};
  var _isInit = true;

  List<bool> _isExpanded = [];

  List<HospitalForUserAttributes> hospitals = [];
  Set<String> ids = {};
  List<String> wardNames = [];
  Map<String,dynamic> areaOfWorkDataToGoToCompetencies;
  User userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<UserProvider>(context,listen: false).getAttributes(context: context,attributeType: 'ward').then((_) {
      userData = Provider.of<UserProvider>(context,listen: false).userData;
      hospitals = Provider.of<UserProvider>(context,listen: false).hospitalsForAttributes;
      selectAll = List.filled(hospitals.length, false);
      if (Provider.of<UserProvider>(context,listen: false).areaOfWorkIdsForCompletingProfile == null || Provider.of<UserProvider>(context,listen: false).areaOfWorkIdsForCompletingProfile.isEmpty) {
        for(int i=0;i<hospitals.length;i++){
        
          selected['${hospitals[i].id}'] = List.filled(hospitals[i].wards.length, false);
        
          for (int w=0; w<hospitals[i].wards.length; w++) {
            for (var v = 0; v<userData.wards.length; v++) {
              if (hospitals[i].wards[w]["id"] == "${userData.wards[v]['id']}") {
                selected['${hospitals[i].id}'][w] = true;
                ids.add(hospitals[i].wards[w]["id"]);
              }
            }
            // to set select all field
            if(!selected['${hospitals[i].id}'].any((element) => element == false) && selected['${hospitals[i].id}'].isNotEmpty ){
              selectAll[i] = true;
            }
          }
        }
      }
      else{
        for(int i=0;i<hospitals.length;i++){

          selected['${hospitals[i].id}'] = List.filled(hospitals[i].wards.length, false);

          for (int w=0; w<hospitals[i].wards.length; w++) {
            for (var v = 0; v<Provider.of<UserProvider>(context,listen: false).areaOfWorkIdsForCompletingProfile.length; v++) {
              if (hospitals[i].wards[w]["id"] == "${Provider.of<UserProvider>(context,listen: false).areaOfWorkIdsForCompletingProfile[v]}") {
                selected['${hospitals[i].id}'][w] = true;
                ids.add(hospitals[i].wards[w]["id"]);
              }
            }
            // to set select all field
            if(!selected['${hospitals[i].id}'].any((element) => element == false) && selected['${hospitals[i].id}'].isNotEmpty ){
              selectAll[i] = true;
            }
          }
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      passedData = ModalRoute.of(context).settings.arguments;
      _isInit = false;
    }
    super.didChangeDependencies();
  }
  bool _isUpdatingProfile=false;


  @override
  Widget build(BuildContext context) {

    final media = MediaQuery.of(context).size;
    final wardsStage = Provider.of<UserProvider>(context).hospitalsStage;


    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details){
          if (!kIsWeb) {
            if (Platform.isIOS) {
              if (details.primaryVelocity.compareTo(0) == 1) {
                Navigator.pop(context);
              }
            }
          }
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              leadingWidth: 120,
              leading: Row(
                children: [
                  IconButton(icon: Icon(passedData==null ? Icons.close:Icons.arrow_back_ios_rounded, color: Colors.white,),
                      onPressed: _isUpdatingProfile==true?(){}:() {
                        Provider.of<UserProvider>(context, listen: false).clearAreaOfWorkForCompletingProfile();
                        Navigator.pop(context);
                      }),
                //  const SizedBox(width: 5.0,),
                //  Provider.of<CallProvider>(context).isInACall ? returnToCallScreen(context) : const SizedBox()
                ],
              ),
              title: const Text("Area of work", style: TextStyle(color: Colors.white,
                  fontSize: 19.0, fontWeight: FontWeight.bold),),
              actions: [
                passedData==null ? const SizedBox() : Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _isUpdatingProfile == true ? const SpinKitCircle(size: 25,color: Colors.white,):InkWell(
                      onTap:  areaOfWorkDataToGoToCompetencies == null ? (){} : () async {
                        setState(() {
                          _isUpdatingProfile = true;
                        });
                        await Provider.of<UserProvider>(context,
                            listen: false).updateProfile(context,
                            // email: userData.email,
                            // firstName: userData.firstName,
                            // lastName: userData.lastName,
                            trustId: userData.trust['id'],
                            // phoneNumber: userData.phone,
                            // employeeNumber: userData.employee_number,
                            userType: userData.roleType,

                            // minimumLevelId: userData.roleType == 2 ? userData.minAcceptedGrade != null ? userData.minAcceptedGrade['id'] : null : userData.minAcceptedBand != null ? userData.minAcceptedBand['id'] : null,
                            // levelId: userData.roleType == 2 ? userData.grade == null ? null : userData.grade['id'] : userData.band == null ? null : userData.band['id'],
                            wards: ids.toList()
                        ).then((_) {
                          setState(() {
                            _isUpdatingProfile = false;
                          });
                        });
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                            color: areaOfWorkDataToGoToCompetencies == null ? Colors.black26:Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )

                    ,
                  ),
                )
              ],
            ),
            body: wardsStage == UsersStage.LOADING
                ?
            SizedBox(
              height: media.height,
              child: Center(child: SpinKitCircle(color: Theme.of(context).primaryColor,size: 50,),),
            )
                :
            SizedBox(
              height: media.height,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: hospitals.length,
                  itemBuilder: (context, i) {
                    // selected['${wards[i].id}'] = ;
                    _isExpanded.add(false);
                    isSelected.add(isChildSelected);
                    return expansionTileCard(
                        context: context,
                        title: "${hospitals[i].name}",
                        doExpansion: (_){
                          setState(() {
                            _isExpanded[i] = ! _isExpanded[i];
                          });
                        },
                        isExpanded: _isExpanded[i],
                        content: [
                          hospitals[i].wards.isEmpty ? const SizedBox() :ListTile(
                            title: Text("Select all", overflow: TextOverflow.ellipsis, maxLines: 2, style: style2,),
                            trailing: !selectAll[i] ? Container(width: 1.0,) : Icon(Icons.done, color: Theme.of(context).primaryColor,),
                            onTap: (){
                              // ids.clear();
                              // wardNames.clear();
                              for(int j=0;j<hospitals[i].wards.length;j++){
                                if (selectAll[i] == true) {
                                  setState(() {
                                    if (ids.contains(hospitals[i].wards[j]['id'])) {
                                      ids.remove(hospitals[i].wards[j]['id']);
                                    }
                                    if (wardNames.contains(hospitals[i].wards[j]['name'])) {
                                      wardNames.remove(hospitals[i].wards[j]['name']);
                                    }
                                    selected['${hospitals[i].id}'][j] = false;
                                    wardNames.add(hospitals[i].wards[j]['name']);
                                    areaOfWorkDataToGoToCompetencies={
                                      "areasIds" : ids.toList(),
                                      "areasNames" : wardNames,
                                      // "TrustId" : trustId
                                    };
                                  });
                                }
                                else{
                                  setState(() {
                                    selected['${hospitals[i].id}'][j] = true;
                                    ids.add(hospitals[i].wards[j]['id']);
                                    wardNames.add(hospitals[i].wards[j]['name']);
                                    areaOfWorkDataToGoToCompetencies={
                                      "areasIds" : ids.toList(),
                                      "areasNames" : wardNames,
                                      // "TrustId" : trustId
                                    };
                                  });
                                }
                              }
                              setState(() {
                                selectAll[i] = !selectAll[i];
                                // isSelected[i].elementAt(index) = !isChildSelected[index];
                              });

                            },
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: hospitals[i].wards.length,
                              itemBuilder: (context, index) {
                                isChildSelected.add(false);
                                return ClipRRect(
                                  borderRadius: index == hospitals[i].wards.length-1 ?
                                  const BorderRadius.only(
                                      bottomLeft: Radius.circular(7),
                                      bottomRight: Radius.circular(7)): BorderRadius.circular(0.0),
                                  child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text("${hospitals[i].wards[index]['name']}", overflow: TextOverflow.ellipsis, maxLines: 2, style: style2,),
                                          trailing: !selected['${hospitals[i].id}'][index] ? Container(width: 1.0,) : Icon(Icons.done, color: Theme.of(context).primaryColor,),
                                          onTap: (){
                                            setState(() {
                                              selected['${hospitals[i].id}'][index] = !selected['${hospitals[i].id}'][index];
                                              if(selected['${hospitals[i].id}'][index]==true){
                                                ids.add(hospitals[i].wards[index]['id']);
                                                wardNames.add(hospitals[i].wards[index]['name']);
                                              }
                                              else {
                                                ids.remove(hospitals[i].wards[index]['id']);
                                                wardNames.remove(hospitals[i].wards[index]['name']);
                                                if(selected['${hospitals[i].id}'].contains(false)){
                                                  selectAll[i] = false;
                                                }
                                              }
                                            });
                                            Provider.of<UserProvider>(context, listen: false).setAreaOfWorkForCompletingProfile(ids.toList());

                                            areaOfWorkDataToGoToCompetencies={
                                              "areasIds" : ids.toList(),
                                              "areasNames" : wardNames,
                                              // "TrustId" : trustId
                                            };
                                          },
                                        ),
                                        index == hospitals[i].wards.length-1 ? const SizedBox() : const Divider(),
                                      ],
                                    ),
                                  ),
                                );
                              }

                          )
                        ]
                    );
                  }

              ),
            )

        ),
      ),
    );
  }
}