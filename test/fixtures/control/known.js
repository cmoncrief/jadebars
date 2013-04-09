(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['known'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [2,'>= 1.0.0-rc.3'];
helpers = helpers || Handlebars.helpers; data = data || {};
  var buffer = "", stack1, escapeExpression=this.escapeExpression, functionType="function";


  buffer += "<div id=\"test\"><h1>This is a test jade file</h1>"
    + escapeExpression(helpers.knownHelper.call(depth0, {hash:{},data:data}))
    + "\n";
  if (stack1 = helpers.unknownHelper) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.unknownHelper; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "</div>";
  return buffer;
  });
})();