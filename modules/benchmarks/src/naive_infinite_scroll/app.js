import {int} from 'facade/lang';
import {reflector} from 'reflection/reflection';
import {getIntParameter, bindAction} from 'e2e_test_lib/benchmark_util';
import {bootstrap, Component, Template, TemplateConfig, ViewPort, Compiler}
    from 'angular/angular';
import {PromiseWrapper} from 'facade/async';
import {ListWrapper} from 'facade/collection';

class App {
  scrollAreas:List<int>;
  scrollTop:int;
  iterationCount:int;
  scrollIncrement:int;

  constructor() {
    this.scrollTop = 0;
    var appSize = getIntParameter('appSize');
    iterationCount = getIntParameter('iterationCount');
    scrollIncrement = getIntParameter('scrollIncrement');
    appSize = appSize > 1 ? appSize - 1 : 0;  // draw at least one table
    scrollAreas = [];
    for (var i = 0; i < appSize; i++) {
      ListWrapper.push(scrollAreas, i);
    }
    bindAction('scroll-app /deep/ #run-btn', function() {
      runBenchmark();
    });
    bindAction('scroll-app /deep/ #reset-btn', function() {
      scrollTop = 0;
    });
  }

  runBenchmark() {
    var n:int = iterationCount;
    var scheduleScroll;
    scheduleScroll = function() {
      PromiseWrapper.setTimeout(function() {
        scrollTop += scrollIncrement;
        n--;
        if (n > 0) {
          scheduleScroll();
        }
      }, 0);
    }
    scheduleScroll();
  }
}

function setupReflector() {
  reflector.registerType(App, {
    'factory': () => new App(),
    'parameters': [],
    'annotations': [
      new Component({
        selector: 'scroll-app',
        template: new TemplateConfig({
          directives: [],
          inline:
            '<div>' +
              '<div style="display: flex">' +
                '<scroll-area scroll-top="scrollTop"></scroll-area>' +
                '<div style="padding-left: 20px">' +
                  '<button id="run-btn">Run</button>' +
                  '<button id="reset-btn">Reset</button>' +
                '</div>' +
              '</div>' +
              '<div ng-if="scrollAreas.length > 0">' +
                '<p>Following tables are only here to add weight to the UI:</p>' +
                '<scroll-area ng-repeat="scrollArea in scrollAreas"></scroll-area>' +
              '</div>' +
            '</div>'
        })
      })
    ]
  });
}
