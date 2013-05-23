var irm_labels = {
    save: "保存",
    processing: "処理中...",
    paginatorPre: "前のページ",
    paginatorNext: "次のページ",
    paginatorBeforePage: "第",
    paginatorAfterPage: "ページ、総計${totalPage}ページ",
    paginatorRecord: "表示は第 ${start} - ${end}行，総計 ${totalCount} 行",
    paginatorBeforeSize: "ページ毎の表示",
    paginatorAfterSize: "行、 ",
    paginatorRefresh: "リフレッシュ",
    atLastSelectOneRecord: "少なくとも1つの行を選択してください。",
    SurveyRequiredError: "案件の必須項目を確認してください。",
    image_from_clipboard: "クリップボードから画像をアップロード",
    sort_this_column: "表示順序を切り換える場合はここをクリック",
    select_all:"全選択",
    select_single: "現項目をクリックで選択",
    search: "検索",
    upload_file_type_error: "ファイルタイプのエラー",
    upload_file_size_error: "ファイルサイズオーバー",
    check_pasted_file_name: "ファイル名の確認",
    reset_order_btn_text: "表示順序の調整",
    save_btn_text: "保存",
    cancel_btn_text: "取消",
    load_data_error: "ロードデータエラー.",
    number_and_cross: "数字とハイフンのみ入力できる",
    number_only: "数字のみ入力できる",
    chr_only: "中国の文字を入力できない",
    uppercase: "大文字とアンダーバーのみ入力できる"
};

var full_calendar_labels = {
    monthNames: ['一月', '二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],
    monthNamesShort: ['一','二','三','四','五','六','七','八','九','十','十一','十二'],
    dayNames: ['日曜日','月曜日','火曜日','水曜日','木曜日','金曜日','土曜日'],
    dayNamesShort: ['日','月','火','水','木','金','土'],
    buttonText: {
        today: '本日',
        month: '月ビュー',
        week: '週ビュー',
        day: '日ビュー'
    }
};

if($.fn.datepicker.dpglobal){
    $.fn.datepicker.dpglobal.dates={
        days: ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日"],
   	    daysShort: ["日", "月", "火", "水", "木", "金", "土", "日"],
   	    daysMin: ["日", "月", "火", "水", "木", "金", "土", "日"],
   	    months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一", "十二"],
   	    monthsShort: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    }
}


