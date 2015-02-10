library benchmarks.src.naive_infinite_scroll.app_dart;

import 'package:angular2/src/facade/lang.dart' show int, isPresent;
import 'package:angular2/src/reflection/reflection.dart' show reflector;
import 'package:angular2/src/test_lib/benchmark_util.dart'
    show getIntParameter, bindAction;
import 'package:angular2/angular2.dart'
    show bootstrap, Component, Template, TemplateConfig, ViewPort, Compiler;
import 'package:angular2/src/facade/async.dart' show PromiseWrapper;
import 'package:angular2/src/facade/collection.dart' show ListWrapper;
import './scroll_area.dart' show ScrollAreaComponent;
import 'package:angular2/directives.dart' show If, Foreach;
import 'package:angular2/src/facade/dom.dart' show DOM, document, Element;

class App {
  List<int> scrollAreas;
  int iterationCount;
  int scrollIncrement;
  App() {
    var appSize = getIntParameter('appSize');
    this.iterationCount = getIntParameter('iterationCount');
    this.scrollIncrement = getIntParameter('scrollIncrement');
    appSize = appSize > 1 ? appSize - 1 : 0;
    this.scrollAreas = [];
    for (var i = 0; i < appSize; i++) {
      ListWrapper.push(this.scrollAreas, i);
    }
    DOM.on(DOM.query('scroll-app /deep/ #run-btn'), 'click', (_) {
      this.runBenchmark();
    });
    DOM.on(DOM.query('scroll-app /deep/ #reset-btn'), 'click', (_) {
      this._getScrollDiv().scrollTop = 0;
      var existingMarker = this._locateFinishedMarker();
      if (isPresent(existingMarker)) {
        DOM.removeChild(document.body, existingMarker);
      }
    });
  }
  runBenchmark() {
    var scrollDiv = this._getScrollDiv();
    int n = this.iterationCount;
    var scheduleScroll;
    scheduleScroll = () {
      PromiseWrapper.setTimeout(() {
        scrollDiv.scrollTop += this.scrollIncrement;
        n--;
        if (n > 0) {
          scheduleScroll();
        } else {
          this._scheduleFinishedMarker();
        }
      }, 0);
    };
    scheduleScroll();
  }
  _scheduleFinishedMarker() {
    var existingMarker = this._locateFinishedMarker();
    if (isPresent(existingMarker)) {
      return;
    }
    PromiseWrapper.setTimeout(() {
      var finishedDiv = DOM.createElement('div');
      finishedDiv.id = 'done';
      DOM.setInnerHTML(finishedDiv, 'Finished');
      DOM.appendChild(document.body, finishedDiv);
    }, 0);
  }
  Element _locateFinishedMarker() {
    return DOM.querySelector(document.body, '#done');
  }
  _getScrollDiv() {
    return DOM.query('body /deep/ #testArea /deep/ #scrollDiv');
  }
}
setupReflectorForApp() {
  reflector.registerType(App, {
    'factory': () {
      return new App();
    },
    'parameters': [],
    'annotations': [
      new Component(
          selector: 'scroll-app',
          template: new TemplateConfig(
              directives: [ScrollAreaComponent, If, Foreach], inline: '''
            <div>
              <div style=\"display: flex\">
                <scroll-area id=\"testArea\"></scroll-area>
                <div style=\"padding-left: 20px\">
                  <button id=\"run-btn\">Run</button>
                  <button id=\"reset-btn\">Reset</button>
                </div>
              </div>
              <div template=\"if scrollAreas.length > 0\">
                <p>Following tables are only here to add weight to the UI:</p>
                <scroll-area template=\"foreach #scrollArea in scrollAreas\"></scroll-area>
              </div>
            </div>'''))
    ]
  });
}
