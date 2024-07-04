import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/features/maps/domain/usecases/fetch_maps_static_image.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';

part 'maps_event.dart';
part 'maps_state.dart';

class MapsBloc extends Bloc<MapsEvent, MapsState> {
  final FetchMapsStaticImage fetchMapsStaticImage;
  MapsBloc(this.fetchMapsStaticImage) : super(MapsInitial()) {
    on<MapsStaticImageFetched>((event, emit) {
      emit(MapsStaticImageLoading());
      final response = fetchMapsStaticImage.call(event.latitudeLongitude);
      response.fold((l) => MapsStaticImageFailure(l.message),
          (r) => emit(MapsStaticImageSuccess(r)));
    });
  }
}
