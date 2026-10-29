/*
 * Copyright (C) 2019-2024 HERE Europe B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 * License-Filename: LICENSE
 */

import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/routing.dart' as HERE;
import 'package:here_sdk/routing.dart';

// A class that creates car Routes with the HERE SDK.
class RouteCalculator {
  late final HERE.RoutingEngine _routingEngine;

  RouteCalculator() {
    try {
      _routingEngine = new HERE.RoutingEngine();
    } on InstantiationException {
      throw Exception('Initialization of RoutingEngine failed.');
    }
  }

  /// Calculates a truck route between the given start and destination waypoints.
  ///
  /// This method uses the HERE SDK's `RoutingEngine` to calculate a truck route
  /// with traffic-optimized updates enabled. The route handle is required for
  /// dynamic routing updates.
  ///
  /// - Parameters:
  ///   - startWaypoint: The starting point of the route.
  ///   - destinationWaypoint: The destination point of the route.
  ///   - calculateRouteCallback: Callback to handle the calculated route or errors.
  void calculateTruckRoute(
      Waypoint startWaypoint, Waypoint destinationWaypoint, CalculateRouteCallback calculateRouteCallback) {
    List<Waypoint> waypoints = [startWaypoint, destinationWaypoint];

    // A route handle is required for the DynamicRoutingEngine to get updates on traffic-optimized routes.
    var routingOptions = HERE.TruckOptions();
    routingOptions.routeOptions.enableRouteHandle = true;

    _routingEngine.calculateTruckRoute(waypoints, routingOptions, calculateRouteCallback);
  }

  /// Calculates traffic information for a given route.
  ///
  /// This method uses the HERE SDK's `RoutingEngine` to calculate traffic conditions
  /// on a specified route. It provides details about traffic on the route, including
  /// the last traveled section and distance traveled on that section.
  ///
  /// - Parameters:
  ///   - currentRoute: The route for which traffic information is to be calculated.
  ///   - lastTraveledSectionIndex: The index of the last traveled section in the route.
  ///   - traveledDistanceOnLastSectionInMeters: The distance traveled on the last section in meters.
  ///   - callback: Callback to handle the traffic information or errors.
  void calculateTrafficOnRoute(HERE.Route currentRoute, int lastTraveledSectionIndex,
      int traveledDistanceOnLastSectionInMeters, HERE.CalculateTrafficOnRouteCallback callback) {
    _routingEngine.calculateTrafficOnRoute(
        currentRoute, lastTraveledSectionIndex, traveledDistanceOnLastSectionInMeters, callback);
  }
}
