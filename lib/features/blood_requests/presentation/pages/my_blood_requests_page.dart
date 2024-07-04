import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/shimmer/blood_card_shimmer.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:myapp/features/blood_requests/presentation/bloc/blood_request_bloc.dart';
import 'package:myapp/features/blood_requests/presentation/widgets/blood_request_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyBloodRequestsPage extends StatefulWidget {
  const MyBloodRequestsPage({
    super.key,
    this.isSelecting = false,
  });

  final bool isSelecting;

  @override
  State<MyBloodRequestsPage> createState() => _MyBloodRequestsPageState();
}

class _MyBloodRequestsPageState extends State<MyBloodRequestsPage> {
  @override
  void initState() {
    fetchMyRequests();
    super.initState();
  }

  fetchMyRequests() {
    context.read<BloodRequestBloc>().add(MyBloodRequestsFetched());
  }

  bool _isLoading = false;
  List<Request> myRequests = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.mybloodReqPage_appBar),
      ),
      body: BlocConsumer<BloodRequestBloc, BloodRequestState>(
        listener: (context, state) {
          if (state is MyBloodRequestFetchLoading) {
            _isLoading = true;
          }
          if (state is MyBloodRequestFetchedSuccess) {
            _isLoading = false;
            myRequests = state.myRequests;
          }
          if (state is MyBloodRequestsFetchedFailure) {
            _isLoading = false;
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (_isLoading) {
            return ListView.builder(
              itemBuilder: (context, index) => const BloodCardShimmer(),
              itemCount: 10,
            );
          }
          if (myRequests.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                    AppLocalizations.of(context)!.mybloodReqPage_notHaveReq),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => fetchMyRequests(),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                      top: index == 0 ? 10.0 : 0, left: 8, right: 8),
                  child: BloodRequestCard(
                    request: myRequests[index],
                    isSelecting: widget.isSelecting,
                  ),
                );
              },
              itemCount: myRequests.length,
            ),
          );
        },
      ),
    );
  }
}
