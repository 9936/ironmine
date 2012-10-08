var irm_labels = {
    save: "保存",
    processing: "处理中...",
    paginatorPre: "上一页",
    paginatorNext: "下一页",
    paginatorBeforePage: "第",
    paginatorAfterPage: "页，共${totalPage}页",
    paginatorRecord: "当前显示第 ${start} - ${end}条，共 ${totalCount} 条",
    paginatorBeforeSize: "每页显示",
    paginatorAfterSize: "条, ",
    paginatorRefresh: "刷新",
    atLastSelectOneRecord: "请至少选择一行数据!",
    SurveyRequiredError: "检查调查问卷必填项!",
    image_from_clipboard: "从剪贴板上传图片",
    sort_this_column: "点击此处切换显示顺序",
    select_all:"全选",
    select_single: "点击选择当前项",
    search: "搜索",
    upload_file_type_error: "文件类型错误",
    upload_file_size_error: "文件超过限定大小",
    check_pasted_file_name: "确认文件名",
    reset_order_btn_text: "调整显示顺序",
    save_btn_text: "保存",
    cancel_btn_text: "取消"
};

if($.fn.datepicker.dpglobal){
    $.fn.datepicker.dpglobal.dates={
	    days: ["星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期天"],
	    daysShort: ["日", "一", "二", "三", "四", "五", "六", "日"],
	    daysMin: ["日", "一", "二", "三", "四", "五", "六", "日"],
	    months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一", "十二"],
	    monthsShort: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    }
}
