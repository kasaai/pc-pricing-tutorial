// The expand/collapse functionality is adapted from https://github.com/distillpub/post--feature-wise-transformations
//   which is licensed under CC BY 4.0 https://creativecommons.org/licenses/by/4.0/
(function() {
    d3.selectAll(".collapsible")
        .on("click", function() {
            d3.selectAll('.content[data-content-name="' + d3.select(this).attr("data-content-name") + '"]')
                .style("display", function() {
                    return d3.select(this).style("display") === "block" ? "none" : "block";
                });
            var symbolSpan = d3.select(this).select("span");
            symbolSpan.html(symbolSpan.html() === "+" ? "-" : "+");
        });
    d3.selectAll(".expand-collapse-button")
        .on("click", function() {
            var mode = d3.select(this).html();
            var contentType = d3.select(this).attr("data-content-type");
            d3.select(this).html(mode === "expand all" ? "collapse all" : "expand all");
            d3.selectAll('.content[data-content-type="' + contentType + '"]')
                .style("display", function() {
                    return mode === "expand all" ? "block" : "none";
                });
            d3.selectAll('.collapsible[data-content-type="' + contentType + '"]').select("span")
                .html(function() {
                    return mode === "expand all" ? "-" : "+";
                });
        });
})();
