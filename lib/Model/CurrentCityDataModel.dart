/*
Genrate By Reza Moaiyedi 1402/03/09
 */
class CurrentCityDataModel {
  String _cityname;
  var _lon;
  var _lat;
  String _main;
  String _descrition;
  var _temp;
  var _temp_min;
  var _temp_max;
  var _pressure;
  var _humidity;
  var _datetime;
  String _country;
  var _sunrise;
  var _sunset;

  CurrentCityDataModel(
      this._cityname,
      this._lon,
      this._lat,
      this._main,
      this._descrition,
      this._temp_min,
      this._temp_max,
      this._pressure,
      this._humidity,
      this._temp,
      this._datetime,
      this._country,
      this._sunrise,
      this._sunset);

  get sunset => _sunset;

  get sunrise => _sunrise;

  String get country => _country;

  get datetime => _datetime;

  get humidity => _humidity;

  get pressure => _pressure;

  get temp_max => _temp_max;

  get temp_min => _temp_min;

  get temp => _temp;

  String get descrition => _descrition;

  String get main => _main;

  get lat => _lat;

  get lon => _lon;

  String get cityname => _cityname;
}
