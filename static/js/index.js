$(function () {
    onLoadTree();
    showTable();
    var pagestyle = function () {
        var container = $("#tab-container");
        var w = $(window).width() - 350;
        if (w < 100) {
            w = 100;
        }
        container.width(w);
        $("#tab-show").width(w).width(w);

        var h = $(window).height() - container.offset().top - 10;
        container.height(h);
    }
    // 窗体加载时自适应宽度
    pagestyle();
    //注册窗体改变大小事件 
    $(window).on("resize", pagestyle);
});