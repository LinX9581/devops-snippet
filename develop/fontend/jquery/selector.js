$('.top10News[hour=1').css('background', '#FFBD00')

$(".top10News").click(async function() {
    let clickHour = $(this).attr('hour')
    $(this).parents('th').attr('editId')
    $('#code').val($(this).parents('tr').find("td[cal=code]").text())
})