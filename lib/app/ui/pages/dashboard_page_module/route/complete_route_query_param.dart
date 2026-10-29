// To parse this JSON data, do
//
//     final shipmentUnloadQueryParam = shipmentUnloadQueryParamFromJson(jsonString);

import 'dart:convert';

CompleteRouteQueryParam completeRouteQueryParamFromJson(String str) => CompleteRouteQueryParam.fromJson(json.decode(str));

String completeRouteQueryParamToJson(CompleteRouteQueryParam data) => json.encode(data.toJson());

class CompleteRouteQueryParam {
  int routeId;

  CompleteRouteQueryParam({
    required this.routeId,
  });

  factory CompleteRouteQueryParam.fromJson(Map<String, dynamic> json) => CompleteRouteQueryParam(
    routeId: json["route_id"],
  );

  Map<String, dynamic> toJson() => {
    "route_id": routeId,
  };
}
