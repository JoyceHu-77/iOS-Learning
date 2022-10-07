//
//  APIResponse.swift
//  ListViewTest
//
//  Created by Blacour on 2022/10/7.
//

import Foundation

/**
 https://api.sunrise-sunset.org/json?data=2020-8-1&lng=37.3230&lat=-122.0322&formatted=0
 */

/**
 {
     "results":{
         "sunrise":"2022-10-07T04:02:51+00:00",
         "sunset":"2022-10-07T14:34:16+00:00",
         "solar_noon":"2022-10-07T09:18:33+00:00",
         "day_length":37885,
         "civil_twilight_begin":"2022-10-07T04:41:25+00:00",
         "civil_twilight_end":"2022-10-07T13:55:42+00:00",
         "nautical_twilight_begin":"2022-10-07T05:31:54+00:00",
         "nautical_twilight_end":"2022-10-07T13:05:13+00:00",
         "astronomical_twilight_begin":"2022-10-07T06:29:51+00:00",
         "astronomical_twilight_end":"2022-10-07T12:07:16+00:00"
     },
     "status":"OK"
 }
 */

struct APIResponse: Codable {
    let results: APIResponseResult
    let status: String
}

struct APIResponseResult: Codable {
    let sunrise: String
    let sunset: String
    let solar_noon: String
    let day_length: Int
    let civil_twilight_begin: String
    let civil_twilight_end: String
    let nautical_twilight_begin: String
    let nautical_twilight_end: String
    let astronomical_twilight_begin: String
    let astronomical_twilight_end: String
}
