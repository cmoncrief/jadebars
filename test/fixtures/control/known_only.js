(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['known_only'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, escapeExpression=this.escapeExpression, functionType="function";


  buffer += "<div id=\"test\"><h1>This is a test jade file</h1>"
    + escapeExpression(helpers.knownHelper.call(depth0, {hash:{},data:data}))
    + "\n"
    + escapeExpression(((stack1 = (depth0 && depth0.unknownHelper)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</div>";
  return buffer;
  });
})();