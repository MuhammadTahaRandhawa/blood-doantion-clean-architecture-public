import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/shimmer/blood_card_shimmer.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:myapp/features/blood_requests/presentation/bloc/blood_request_bloc.dart';
import 'package:myapp/features/blood_requests/presentation/cubit/blood_request_cubit.dart';
import 'package:myapp/features/blood_requests/presentation/pages/add_new_blood_request_page.dart';
import 'package:myapp/features/blood_requests/presentation/widgets/blood_request_card.dart';
import 'package:myapp/features/blood_requests/presentation/widgets/blood_request_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodRequestsPage extends StatefulWidget {
  const BloodRequestsPage({super.key});

  @override
  State<BloodRequestsPage> createState() => _BloodRequestsPageState();
}

class _BloodRequestsPageState extends State<BloodRequestsPage>
    with AutomaticKeepAliveClientMixin {
  User? _currentUser;
  List<Request> bloodRequests = [];
  List<Request> filteredRequests = [];
  bool _isLoading = false;
  int radius = 4;
  List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  int appBarindex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentUser = context.read<UserCubit>().state;
    fetchRequests();
    _scrollController.addListener(_getAppBarWidget);
    // Future.delayed(
    //   Duration(seconds: 5),
    //   () {
    //     setState(() {
    //       appBarindex = 1;
    //     });
    //   },
    // );
  }

  _getAppBarWidget() {
    if (_scrollController.offset ==
        _scrollController.position.minScrollExtent) {
      setState(() {
        appBarindex = 0;
      });
    } else {
      setState(() {
        appBarindex = 1;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bloodRequests = context.watch<BloodRequestCubit>().state;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: onAddNewRequest,
        heroTag: 'add request hero',
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<BloodRequestBloc, BloodRequestState>(
        listener: (context, state) async {
          if (state is BloodRequestInsideRadiusFetchLoading) {
            _isLoading = true;
          }
          if (state is BloodRequestInsideARadiusFetchedFailure) {
            _isLoading = false;
            showSnackBar(context, state.message);
          }
          if (state is BloodRequestInsideARadiusFetchedSuccess) {
            _isLoading = false;
            context
                .read<BloodRequestCubit>()
                .initializeBloodRequests(state.bloodRequests);
          }
        },
        builder: (context, state) {
          if (!_isLoading) {
            filteredRequests = context.read<BloodRequestCubit>().applyFilter(
                requests: bloodRequests,
                bloodGroups: bloodGroups,
                radius: radius,
                currentUserPoints: LatitudeLongitude(
                    latitude: _currentUser!.location.latitude,
                    longitude: _currentUser!.location.longitude));
          }
          return Scaffold(
              body: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 10000),
                curve: Curves.easeIn,
                child: appBarindex == 0
                    ? BloodRequestHeader(
                        filteredRequests: filteredRequests,
                        bloodGroups: bloodGroups,
                        onChangedBloodGroups: onChangedBloodGroups,
                        onChangedRadius: onChangedRadius,
                        radius: radius,
                      )
                    : AppBar(
                        title: Text(
                            AppLocalizations.of(context)!.bloodReqPage_appBar),
                      ),
              ),
              if (_isLoading)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemBuilder: (context, index) {
                      return const BloodCardShimmer();
                    },
                    itemCount: 10,
                  ),
                ),
              if (!_isLoading)
                if (filteredRequests.isEmpty)
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async => await fetchRequests(),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                kIsWeb
                                    ? 'images/searching_did_not_find.png'
                                    : 'assets/images/searching_did_not_find.png',
                                height: 200,
                                alignment: Alignment.center,
                              ),
                              Text(
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                  textAlign: TextAlign.center,
                                  AppLocalizations.of(context)!
                                      .bloodReqPage_notFindReq),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              if (filteredRequests.isNotEmpty)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => await fetchRequests(),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 10),
                      itemBuilder: (context, index) =>
                          BloodRequestCard(request: filteredRequests[index]),
                      itemCount: filteredRequests.length,
                    ),
                  ),
                ),
            ],
          ));
        },
      ),
    );
  }

  fetchRequests() {
    context.read<BloodRequestBloc>().add(BloodRequestInsideARadiusFetched(
        LatitudeLongitude(
            latitude: _currentUser!.location.latitude,
            longitude: _currentUser!.location.longitude)));
  }

  onAddNewRequest() {
    _isLoading = false;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddNewBloodRequestPage(),
      ),
    );
  }

  onChangedBloodGroups(List<String> updatedBloodGroups) {
    setState(() {
      bloodGroups = updatedBloodGroups;
    });
  }

  onChangedRadius(int updatedRadius) {
    setState(() {
      radius = updatedRadius;
    });
  }
}
