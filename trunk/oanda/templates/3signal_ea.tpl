<chart>
symbol=GBPJPY
period=60
leftpos=1940
digits=3
scale=8
graph=1
fore=0
grid=0
volume=0
scroll=1
shift=1
ohlc=1
askline=1
days=0
descriptions=0
shift_size=20
fixed_pos=0
window_left=66
window_top=66
window_right=1080
window_bottom=381
window_type=3
background_color=0
foreground_color=16777215
barup_color=65280
bardown_color=65280
bullcandle_color=0
bearcandle_color=16777215
chartline_color=65280
volumes_color=3329330
grid_color=10061943
askline_color=255
stops_color=255

<window>
height=100
<indicator>
name=main
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=3_Level_ZZ_Semafor
flags=275
window_num=0
<inputs>
Period1=5.00000000
Period2=13.00000000
Period3=34.00000000
Dev_Step_1=1,3
Dev_Step_2=8,5
Dev_Step_3=21,12
Symbol_1_Kod=140
Symbol_2_Kod=141
Symbol_3_Kod=142
</inputs>
</expert>
shift_0=0
draw_0=3
color_0=1993170
style_0=0
weight_0=1
arrow_0=140
shift_1=0
draw_1=3
color_1=1993170
style_1=0
weight_1=1
arrow_1=140
shift_2=0
draw_2=3
color_2=8721863
style_2=0
weight_2=2
arrow_2=141
shift_3=0
draw_3=3
color_3=8721863
style_3=0
weight_3=2
arrow_3=141
shift_4=0
draw_4=3
color_4=65535
style_4=0
weight_4=4
arrow_4=142
shift_5=0
draw_5=3
color_5=65535
style_5=0
weight_5=4
arrow_5=142
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=Heiken_Ashi_Smoothed
flags=275
window_num=0
<inputs>
MaMetod=2
MaPeriod=6
MaMetod2=3
MaPeriod2=2
</inputs>
</expert>
shift_0=0
draw_0=2
color_0=255
style_0=0
weight_0=1
shift_1=0
draw_1=2
color_1=16711680
style_1=0
weight_1=1
shift_2=0
draw_2=2
color_2=255
style_2=0
weight_2=2
shift_3=0
draw_3=2
color_3=16711680
style_3=0
weight_3=2
period_flags=0
show_data=1
</indicator>
</window>

<expert>
name=3_signal
flags=343
window_num=0
<inputs>
InitialTrailingStop=500
TrailingStop=150
trailingstop=150
mintrailingstop=500
mintrailingstopavgcosting=500
gmtoffset=7
createneworders=1
current_currency=1
magic=1234
max_orders=2
overall_max_orders=-1
lots=0.05000000
UseAlerts=1
UseEmailAlerts=1
filesave=0
create_avg_orders=1
magic1=1231
magic2=1232
magic3=1233
magic4=1234
</inputs>
</expert>
</chart>
