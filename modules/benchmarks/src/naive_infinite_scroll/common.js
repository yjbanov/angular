import {PromiseWrapper} from 'facade/async';
import {ListWrapper, MapWrapper} from 'facade/collection';

var ITEMS = 1000;
var ITEM_HEIGHT = 40;
var VISIBLE_ITEMS = 17;

var HEIGHT = ITEMS * ITEM_HEIGHT;
var VIEW_PORT_HEIGHT = ITEM_HEIGHT * VISIBLE_ITEMS;

var COMPANY_NAME_WIDTH = 100;
var OPPORTUNITY_NAME_WIDTH = 100;
var OFFERING_NAME_WIDTH = 100;
var ACCOUNT_CELL_WIDTH = 50;
var BASE_POINTS_WIDTH = 50;
var KICKER_POINTS_WIDTH = 50;
var STAGE_BUTTONS_WIDTH = 220;
var BUNDLES_WIDTH = 120;
var DUE_DATE_WIDTH = 100;
var END_DATE_WIDTH = 100;
var AAT_STATUS_WIDTH = 100;
var ROW_WIDTH = COMPANY_NAME_WIDTH +
  OPPORTUNITY_NAME_WIDTH +
  OFFERING_NAME_WIDTH +
  ACCOUNT_CELL_WIDTH +
  BASE_POINTS_WIDTH +
  KICKER_POINTS_WIDTH +
  STAGE_BUTTONS_WIDTH +
  BUNDLES_WIDTH +
  DUE_DATE_WIDTH +
  END_DATE_WIDTH +
  AAT_STATUS_WIDTH;

var STATUS_LIST = [
    'Planned', 'Pitched', 'Won', 'Lost'
];

var AAT_STATUS_LIST = [
    'Active', 'Passive', 'Abandoned'
];

// Imitate Streamy entities.

// Just a non-trivial object. Nothing fancy or correct.
class CustomDate {
  year: int;
  month: int;
  day: int;

  constructor(y:int, m:int, d:int) {
    this.year = y;
    this.month = m;
    this.day = d;
  }

  addDays(days:int):CustomDate {
    return new CustomDate(this.year, this.month, this.day + days);
  }

  static now():CustomDate {
    return new CustomDate(2014, 1, 28);
  }
}

class RawEntity {

  _data:Map;

  constructor() {
    this._data = MapWrapper.create();
  }
  
  get(key:String) {
    if (!key.contains('.')) {
      return _data[key];
    }
    var pieces = key.split('.');
    var last = pieces.removeLast();
    var target = _resolve(pieces, this);
    if (target == null) {
      return null;
    }
    return target[last];
  }

  set(key:String, value) {
    if (!key.contains('.')) {
      _data[key] = value;
      return;
    }
    var pieces = key.split('.');
    var last = pieces.removeLast();
    var target = _resolve(pieces, this);
    target[last] = value;
  }

  remove(key:String) {
    if (!key.contains('.')) {
      return _data.remove(key);
    }
    var pieces = key.split('.');
    var last = pieces.removeLast();
    var target = _resolve(pieces, this);
    return target.remove(last);
  }

  _resolve(pieces, start) {
    var cur = start;
    for (var i = 0; i < pieces.length; i++) {
      cur = cur[pieces[i]];
      if (cur == null) {
        return null;
      }
    }
    return cur;
  }
}

class Company extends RawEntity {
  get name():String { return this.get('name'); }
  set name(val:String) {
    this.set('name', val);
  }
}

class Offering extends RawEntity {
  get name():String { return this.get('name'); }
  set name(val:String) {
    this.set('name', val);
  }

  get company():Company { return this.get('company'); }
  set company(val:Company) {
    this.set('company', val);
  }

  get opportunity():Opportunity { return this.get('opportunity'); }
  set opportunity(val:Opportunity) {
    this.set('opportunity', val);
  }

  get account():Account { return this.get('account'); }
  set account(val:Account) {
    this.set('account', val);
  }

  get basePoints():int { return this.get('basePoints'); }
  set basePoints(val:int) {
    this.set('basePoints', val);
  }

  get kickerPoints():int { return this.get('kickerPoints'); }
  set kickerPoints(val:int) {
    this.set('kickerPoints', val);
  }

  get status():String { return this.get('status'); }
  set status(val:String) {
    this.set('status', val);
  }

  get bundles():String { return this.get('bundles'); }
  set bundles(val:String) {
    this.set('bundles', val);
  }

  get dueDate():CustomDate { return this.get('dueDate'); }
  set dueDate(val:CustomDate) {
    this.set('dueDate', val);
  }

  get endDate():CustomDate { return this.get('endDate'); }
  set endDate(val:CustomDate) {
    this.set('endDate', val);
  }

  get aatStatus():String { return this.get('aatStatus'); }
  set aatStatus(val:String) {
    this.set('aatStatus', val);
  }
}

class Opportunity extends RawEntity {
  get name():String { return this.get('name'); }
  set name(val:String) {
    this.set('name', val);
  }
}

class Account extends RawEntity {
  get accountId():int { return this.get('accountId'); }
  set accountId(val:int) {
    this.set('accountId', val);
  }
}
