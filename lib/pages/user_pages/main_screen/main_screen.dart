import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zentri/models/user_model.dart';
import 'package:zentri/pages/user_pages/main_screen/widgets/alamat_lengkap.dart';
import 'package:zentri/pages/user_pages/main_screen/widgets/dashboard_header.dart';
import 'package:zentri/pages/user_pages/main_screen/widgets/filter_tanggal.dart';
import 'package:zentri/pages/user_pages/main_screen/widgets/list_absensi.dart';
import 'package:zentri/pages/user_pages/main_screen/widgets/profile_sheet.dart';
import 'package:zentri/pages/user_pages/main_screen/widgets/tanggal_waktu.dart';
import 'package:zentri/pages/user_pages/main_screen/widgets/welcome_section.dart';
import 'package:zentri/services/providers/attendance_provider.dart';
import 'package:zentri/services/providers/maps_provider.dart';
import 'package:zentri/services/providers/profile_provider.dart';
import 'package:zentri/services/providers/widget_provider.dart';
import 'package:zentri/services/shared_preferences/prefs_handler.dart';
import 'package:zentri/utils/colors/app_colors.dart';
import 'package:zentri/utils/styles/app_btn_style.dart';
import 'package:zentri/utils/widgets/dialog.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      await Provider.of<AttendanceProvider>(
        context,
        listen: false,
      ).getListAbsensi();
      await Provider.of<ProfileProvider>(
        context,
        listen: false,
      ).getdataProfile();
    });
  }

  TextEditingController tglStart = TextEditingController(text: "Semua");
  TextEditingController tglEnd = TextEditingController(text: "Semua");

  @override
  Widget build(BuildContext context) {
    final mapsProv = Provider.of<MapsProvider>(context);
    final attendProv = Provider.of<AttendanceProvider>(context);
    final profileProv = Provider.of<ProfileProvider>(context);
    final widgetProv = Provider.of<WidgetProvider>(context);

    bool isLoading = attendProv.isLoading;
    bool isLoadProfile = profileProv.isLoading;

    Data profile = profileProv.dataProfile;
    String name = profile.name!;

    return Scaffold(
      backgroundColor: Colors.white,

      // appBar: AppBar(
      //   backgroundColor: AppColors.background,
      //   actions: [
      //     isLoadProfile
      //         ? CircleAvatar(
      //           backgroundColor: AppColors.primary,
      //           child: CircularProgressIndicator(color: AppColors.border),
      //         )
      //         : GestureDetector(
      //           onTap: () {
      //             showProfileSheet(
      //               context,
      //               profileProv,
      //               name: profile.name!,
      //               email: profile.email!,
      //               createdAt: profile.createdAt!,
      //               updatedAt: profile.updatedAt!,
      //             );
      //           },
      //           child: CircleAvatar(
      //             backgroundColor: AppColors.primary,
      //             child: Icon(Icons.person, color: AppColors.background),
      //           ),
      //         ),
      //     SizedBox(width: 20),
      //   ],
      // ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            dashboardHeader(context, profileProv, profile),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: welcomeSection(context, name),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: mapWidget(context, mapsProv),
            ),
            // _buildMainContent(),
            // showTanggalWaktu(context),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 16, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Expanded(
                          child: datePicker(
                            context,
                            widgetProv,
                            tglStart,
                            "Start",
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: datePicker(context, widgetProv, tglEnd, "End"),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            print(
                              "tgl start: ${tglStart.text}\ntgl end: ${tglEnd.text}",
                            );
                            if (tglStart.text == "Semua" &&
                                tglEnd.text == "Semua") {
                              await attendProv.getListAbsensi();
                            } else if (tglStart.text != "Semua" &&
                                tglEnd.text != "Semua") {
                              await attendProv.getListAbsensiFiltered(
                                tgl_start: tglStart.text,
                                tgl_end: tglEnd.text,
                              );
                            } else {
                              CustomDialog().message(
                                context,
                                pesan:
                                    "Mohon Jangan Nanggung nanggung kasih filter.\nIsi kedua tanggalnya!!!",
                              );
                            }
                          },
                          style: AppBtnStyle.normal,
                          child: Icon(
                            Icons.filter_alt_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          tglStart.text = "Semua";
                          tglEnd.text = "Semua";
                        });
                      },
                      child: Text(
                        "reset filter",
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                    isLoading
                        ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accent,
                          ),
                        )
                        : Expanded(
                          child: buildListAbsensi(
                            attendProv.listAbsen,
                            attendProv,
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          CustomDialog().loading(context);
          await mapsProv.fetchLocation();
          CustomDialog().hide(context);

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              String _currentAddress = mapsProv.currentAddress;
              String _currentLatLong = mapsProv.currentLatLong;
              final _currentLat = mapsProv.currentLat;
              final _currentLong = mapsProv.currentLong;

              final _jalan = mapsProv.jalan;
              final _kelurahan = mapsProv.kelurahan;
              final _kecamatan = mapsProv.kecamatan;
              final _kota = mapsProv.kota;
              final _provinsi = mapsProv.provinsi;
              final _negara = mapsProv.negara;
              final _kodePos = mapsProv.kodePos;

              final attendProv = Provider.of<AttendanceProvider>(context);

              return Container(
                padding: EdgeInsets.all(16),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 300,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(_currentLat, _currentLong),
                            zoom: 14.4746,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            if (!_controller.isCompleted) {
                              _controller.complete(controller);
                            }
                          },
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          compassEnabled: true,
                          gestureRecognizers: {
                            Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                            ),
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Check out Kantor"),
                                    content: buildAlamatLengkap(
                                      jalan: _jalan,
                                      kelurahan: _kelurahan,
                                      kecamatan: _kecamatan,
                                      kota: _kota,
                                      provinsi: _provinsi,
                                      negara: _negara,
                                      kodePos: _kodePos,
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          String token =
                                              await PrefsHandler.getToken();
                                          print("isi token: $token");
                                          await attendProv.checkOutUser(
                                            context,
                                            lat: _currentLat,
                                            long: _currentLong,
                                            location: _currentLatLong,
                                            address: _currentAddress,
                                            token: token,
                                          );
                                        },
                                        style: AppBtnStyle.merah,
                                        child: Text("Check out"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.logout, color: Colors.white),
                            label: const Text("Check-out"),
                            style: AppBtnStyle.merah,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Check in Kantor"),
                                    content: buildAlamatLengkap(
                                      jalan: _jalan,
                                      kelurahan: _kelurahan,
                                      kecamatan: _kecamatan,
                                      kota: _kota,
                                      provinsi: _provinsi,
                                      negara: _negara,
                                      kodePos: _kodePos,
                                    ),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          //showdialogizin
                                          TextEditingController _contAlasan =
                                              new TextEditingController();
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Izin Kantor"),
                                                content: TextField(
                                                  controller: _contAlasan,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Masukkan alasan izin",
                                                  ),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      attendProv
                                                          .checkInIzinUser(
                                                            context,
                                                            lat: _currentLat,
                                                            long: _currentLong,
                                                            address:
                                                                _currentAddress,
                                                            alasan:
                                                                _contAlasan
                                                                    .text,
                                                          );
                                                    },
                                                    style: AppBtnStyle.normal,
                                                    child: Text("Izin"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          "Izin",
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),

                                      ElevatedButton(
                                        onPressed: () async {
                                          String token =
                                              await PrefsHandler.getToken();
                                          print("isi token: $token");
                                          await attendProv.checkInUser(
                                            context,
                                            lat: _currentLat,
                                            long: _currentLong,
                                            address: _currentAddress,
                                            token: token,
                                          );
                                        },
                                        style: AppBtnStyle.hijau,
                                        child: Text("Check in"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.login, color: Colors.white),
                            label: const Text("Check-In"),
                            style: AppBtnStyle.hijau,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.event_available_outlined, color: Colors.white),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Container mapWidget(BuildContext context, MapsProvider mapsProv) {
    String _currentAddress = mapsProv.currentAddress;
    String _currentLatLong = mapsProv.currentLatLong;
    final _currentLat = mapsProv.currentLat;
    final _currentLong = mapsProv.currentLong;

    final _jalan = mapsProv.jalan;
    final _kelurahan = mapsProv.kelurahan;
    final _kecamatan = mapsProv.kecamatan;
    final _kota = mapsProv.kota;
    final _provinsi = mapsProv.provinsi;
    final _negara = mapsProv.negara;
    final _kodePos = mapsProv.kodePos;

    final attendProv = Provider.of<AttendanceProvider>(context);
    return Container(
      // padding: EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(_currentLat, _currentLong),
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) {
                  if (!_controller.isCompleted) {
                    _controller.complete(controller);
                  }
                },
                mapType: MapType.normal,
                myLocationEnabled: true,
                compassEnabled: true,
                gestureRecognizers: {
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
              ),
            ),
          ),

          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Check out Kantor"),
                          content: buildAlamatLengkap(
                            jalan: _jalan,
                            kelurahan: _kelurahan,
                            kecamatan: _kecamatan,
                            kota: _kota,
                            provinsi: _provinsi,
                            negara: _negara,
                            kodePos: _kodePos,
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                String token = await PrefsHandler.getToken();
                                print("isi token: $token");
                                await attendProv.checkOutUser(
                                  context,
                                  lat: _currentLat,
                                  long: _currentLong,
                                  location: _currentLatLong,
                                  address: _currentAddress,
                                  token: token,
                                );
                              },
                              style: AppBtnStyle.merah,
                              child: Text("Check out"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text("Check-out"),
                  style: AppBtnStyle.merah,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Check in Kantor"),
                          content: buildAlamatLengkap(
                            jalan: _jalan,
                            kelurahan: _kelurahan,
                            kecamatan: _kecamatan,
                            kota: _kota,
                            provinsi: _provinsi,
                            negara: _negara,
                            kodePos: _kodePos,
                          ),
                          actionsAlignment: MainAxisAlignment.spaceBetween,
                          actions: [
                            TextButton(
                              onPressed: () {
                                //showdialogizin
                                TextEditingController _contAlasan =
                                    new TextEditingController();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Izin Kantor"),
                                      content: TextField(
                                        controller: _contAlasan,
                                        decoration: InputDecoration(
                                          hintText: "Masukkan alasan izin",
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            attendProv.checkInIzinUser(
                                              context,
                                              lat: _currentLat,
                                              long: _currentLong,
                                              address: _currentAddress,
                                              alasan: _contAlasan.text,
                                            );
                                          },
                                          style: AppBtnStyle.normal,
                                          child: Text("Izin"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                "Izin",
                                style: TextStyle(color: AppColors.textPrimary),
                              ),
                            ),

                            ElevatedButton(
                              onPressed: () async {
                                String token = await PrefsHandler.getToken();
                                print("isi token: $token");
                                await attendProv.checkInUser(
                                  context,
                                  lat: _currentLat,
                                  long: _currentLong,
                                  address: _currentAddress,
                                  token: token,
                                );
                              },
                              style: AppBtnStyle.hijau,
                              child: Text("Check in"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: const Text("Check-In"),
                  style: AppBtnStyle.hijau,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildMainContent() {
  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.all(24.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Welcome and date/time section
  //         welcomeSection(context, pro),
  //         const SizedBox(height: 24),

  //         // // Location section
  //         // buildLocationSection(),
  //         // const SizedBox(height: 24),

  //         // // Attendance section
  //         // buildAttendanceSection(),
  //         // const SizedBox(height: 32),

  //         // // Work hours section
  //         // buildWorkHoursSection(),
  //         // const SizedBox(height: 32),

  //         // // Bottom navigation buttons
  //         // buildNavButtons(),
  //       ],
  //     ),
  //   );
  // }
}
