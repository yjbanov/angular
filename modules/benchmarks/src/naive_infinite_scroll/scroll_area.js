import {int, FINAL} from 'facade/lang';
import {reflector} from 'reflection/reflection';
import {getIntParameter, bindAction} from 'e2e_test_lib/benchmark_util';
import {Component, Template, TemplateConfig, ViewPort, Compiler}
    from 'angular/angular';
import {PromiseWrapper} from 'facade/async';
import {ListWrapper} from 'facade/collection';
import {Element} from 'facade/dom';
import {Math} from 'facade/math';

import {Offering, ITEMS, ITEM_HEIGHT, VISIBLE_ITEMS, VIEW_PORT_HEIGHT,
    ROW_WIDTH, HEIGHT} from './common';
import {generateOfferings} from './random_data';

class ScrollAreaComponent {
  _fullList:List<Offering>;
  visibleItems:List<Offering>;

  // Init empty maps and populate later. There seems to be a bug in Angular
  // that makes it choke on pre-populated style maps.
  paddingStyle;
  innerStyle;
  scrollDivStyle;
  scrollTop:int;

  ScrollAreaComponent() {
    this.paddingStyle = {};
    this.innerStyle = {};
    this.scrollDivStyle = {};
    this._fullList = generateOfferings(ITEMS);
    this.visibleItems = [];
    this.scrollTop = 0;
    scrollDivStyle.addAll({
        'height': '${VIEW_PORT_HEIGHT}px',
        'width': '1000px',
        'border': '1px solid #000',
        'overflow': 'scroll',
    });
    innerStyle['width'] = '${ROW_WIDTH}px';
    onScroll();
  }

  onScroll() {
    var scrollY = scrollTop;
    var iStart = scrollY == 0 ? 0 : (scrollY / ITEM_HEIGHT).floor();
    var iEnd = Math.min(iStart + VISIBLE_ITEMS + 1, _fullList.length);
    var padding = iStart * ITEM_HEIGHT;
    innerStyle['height'] = '${HEIGHT - padding}px';
    paddingStyle['height'] = '${padding}px';
    visibleItems.clear();
    visibleItems.addAll(_fullList.getRange(iStart, iEnd));
  }
}

export function setupReflector() {
  reflector.registerType(ScrollAreaComponent, {
    'factory': () => new ScrollAreaComponent(),
    'parameters': [],
    'annotations': [
      new Component({
        selector: 'scroll-area',
        template:
          '<div>' +
              '<div id="scrollDiv" ' +
                   'ng-style="scrollDivStyle" ' +
                   'ng-scroll="onScroll()">' +
                  '<div ng-style="paddingStyle"></div>' +
                  '<div ng-style="innerStyle">' +
                      '<scroll-item ' +
                          'ng-repeat="item in visibleItems" ' +
                          'offering="item">' +
                      '</scroll-item>' +
                  '</div>' +
              '</div>' +
          '</div>',
        map: {
          'scroll-top': '=>scrollTop',
        }
      })
    ]
  });
}
