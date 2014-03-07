(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['known'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, escapeExpression=this.escapeExpression, functionType="function";


  buffer += "<div id=\"test\"><h1>This is a test jade file</h1>"
    + escapeExpression(helpers.knownHelper.call(depth0, {hash:{},data:data}))
    + "\n";
  if (helper = helpers.unknownHelper) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.unknownHelper); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</div>";
  return buffer;
  });
})();