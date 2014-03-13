//
//  Baizi.h
//  astro
//
//  Created by kjubo on 14-3-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#ifndef astro_Paipan_h
#define astro_Paipan_h

#define __TianGan @[@"甲", @"乙", @"丙", @"丁", @"戊", @"己", @"庚", @"辛", @"壬", @"癸"]
#define __DiZhi   @[@"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", @"亥"]
#define __ShiShen @[@"比肩", @"劫财", @"正印", @"枭神", @"食神", @"伤官", @"正财", @"偏财", @"正官", @"七杀"]
#define __ShuXing @[@"阴", @"阳"]

#define __Nayin   @{\
@10000 : @"海中金",\
@10101 : @"海中金",\
@10202 : @"炉中火",\
@10303 : @"炉中火",\
@10404 : @"大林木",\
@10505 : @"大林木",\
@10606 : @"路旁土",\
@10707 : @"路旁土",\
@10808 : @"剑锋金",\
@10909 : @"剑锋金",\
@10010 : @"山头火",\
@10111 : @"山头火",\
@10200 : @"涧下水",\
@10301 : @"涧下水",\
@10402 : @"城头土",\
@10503 : @"城头土",\
@10604 : @"白蜡金",\
@10705 : @"白蜡金",\
@10806 : @"杨柳木",\
@10907 : @"杨柳木",\
@10008 : @"泉中水",\
@10109 : @"泉中水",\
@10210 : @"屋上土",\
@10311 : @"屋上土",\
@10400 : @"霹雳火",\
@10501 : @"霹雳火",\
@10602 : @"松柏木",\
@10703 : @"松柏木",\
@10804 : @"长流水",\
@10905 : @"长流水",\
@10006 : @"砂中金",\
@10107 : @"砂中金",\
@10208 : @"山下火",\
@10309 : @"山下火",\
@10410 : @"平地木",\
@10511 : @"平地木",\
@10600 : @"壁上土",\
@10701 : @"壁上土",\
@10802 : @"金箔金",\
@10903 : @"金箔金",\
@10004 : @"覆灯火",\
@10105 : @"覆灯火",\
@10206 : @"天河水",\
@10307 : @"天河水",\
@10408 : @"大驿土",\
@10509 : @"大驿土",\
@10610 : @"钗钏金",\
@10711 : @"钗钏金",\
@10800 : @"桑松木",\
@10901 : @"桑松木",\
@10002 : @"大溪水",\
@10103 : @"大溪水",\
@10204 : @"沙中土",\
@10305 : @"沙中土",\
@10406 : @"天上火",\
@10507 : @"天上火",\
@10608 : @"石榴木",\
@10709 : @"石榴木",\
@10810 : @"大海水",\
@10911 : @"大海水",\
}

//节气
#define __JieQi   @[@"小寒", @"立春", @"惊蛰", @"清明", @"立夏", @"芒种", @"小暑", @"立秋", @"白露", @"寒露", @"立冬", @"大雪"]
#define __ZhongQi @[@"大寒", @"雨水", @"春分", @"谷雨", @"小满", @"夏至", @"大暑", @"处暑", @"秋分", @"霜降", @"小雪", @"冬至"]
#define __AllJieQi @[@"小寒", @"大寒", @"立春", @"雨水", @"惊蛰", @"春分", @"清明", @"谷雨", @"立夏", @"小满", @"芒种", @"夏至", @"小暑", @"大暑", @"立秋", @"处暑", @"白露", @"秋分", @"寒露", @"霜降", @"立冬", @"小雪", @"大雪", @"冬至"]

//
//农历
#define __NongliMonth @{\
@1  : @"正",\
@2  : @"二",\
@3  : @"三",\
@4  : @"四",\
@5  : @"五",\
@6  : @"六",\
@7  : @"七",\
@8  : @"八",\
@9  : @"九",\
@10 : @"十",\
@11 : @"十一",\
@12 : @"腊",\
@101: @"润正",\
@102: @"润二",\
@103: @"润三",\
@104: @"润四",\
@105: @"润五",\
@106: @"润六",\
@107: @"润七",\
@108: @"润八",\
@109: @"润九",\
@110: @"润十",\
@111: @"润十一",\
@112: @"润腊",\
}

#define __NongliDay @[@"占位", @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"]

//六爻基础
#define __LYLiuQin @[@"父母", @"官鬼", @"兄弟", @"妻财", @"子孙"]

//紫薇基础
#define __ZiWeiRunYue @["按当月算", @"按下月算", @"前15日算当月，后15日算下月"]
#define __ZiWeiMingJu @{\
@2  :   @"水二局",\
@3  :   @"木三局",\
@4  :   @"金四局",\
@5  :   @"土五局",\
@6  :   @"火六局",}
#define __ZiWeiGong @[@"★命宫", @"兄弟宫", @"夫妻宫", @"子女宫", @"财帛宫", @"疾厄宫", @"迁移宫", @"仆役宫", @"官禄宫", @"田宅宫", @"福德宫", @"父母宫"]
#define __ZiWeiStar @[\
@"紫薇", @"天机", @"太阳", @"武曲", @"天同", @"廉贞",\
@"天府", @"太阴", @"贪狼", @"巨门", @"天相", @"天梁", @"七杀", @"破军",\
@"文曲", @"文昌", @"左辅", @"右弼", @"天魁", @"天钺",\
@"禄存", @"天马",\
@"擎羊", @"陀罗", @"火星", @"铃星",\
@"地空", @"地劫",\
@"天宫", @"天福",\
@"截空", @"旬空", @"红鸾", @"天喜", @"龙池", @"凤阁", @"三台", @"八座", @"天才", @"天寿",\
@"孤辰", @"寡宿", @"台辅", @"封诰", @"天刑", @"天姚", @"解神", @"天巫", @"天月", @"阴煞",\
@"天伤", @"天使", @"恩光", @"天贵", @"天厨", @"天空", @"天哭", @"天虚", @"劫杀", @"大耗",\
@"蜚廉", @"破碎", @"华盖", @"咸池", @"龙德", @"月德", @"天德", @"年解"]

#define __ZiWeiSihua      @[@" ", @"禄", @"权", @"科", @"忌"]
#define __ZiWeiMiaowang   @[@" ", @"庙", @"旺", @"平", @"地", @"闲", @"陷"]
#define __ZiWeiChangSheng @[@"长生", @"沐浴", @"冠带", @"临官", @"帝旺", @"衰", @"病", @"死", @"墓", @"绝", @"胎", @"养"]
#define __ZiWeiTaiSui     @[@"岁建", @"晦气", @"丧门", @"贯索", @"官符", @"小耗", @"大耗", @"龙德", @"白虎", @"天德", @"吊客", @"病符"]
#define __ZiWeiJiangQian  @[@"将星", @"攀鞍", @"岁驿", @"息神", @"华盖", @"劫煞", @"灾煞", @"天煞", @"指背", @"咸池", @"月煞", @"亡神"]
#define __ZiWeiBoShi      @[@"博士", @"力士", @"青龙", @"小耗", @"将军", @"奏书", @"飞廉", @"喜神", @"病符", @"大耗", @"伏兵", @"官府"]

const int __WuXing[10][10] = {
    {0,1,3,2,9,8,6,7,4,5},
    {1,0,2,3,8,9,7,6,5,4},
    {4,5,0,1,3,2,9,8,7,6},
    {5,4,1,0,2,3,8,9,6,7},
    {7,6,4,5,0,1,3,2,9,8},
    {6,7,5,4,1,0,2,3,8,9},
    {9,8,7,6,4,5,0,1,3,2},
    {8,9,6,7,5,4,1,0,2,3},
    {3,2,9,8,7,6,4,5,0,1},
    {2,3,8,9,6,7,5,4,1,0},
};

//#region 占星术基础
//public enum AstroType
//{
//    [Description("本命盘")]
//    benming = 1,
//    [Description("合盘")]
//    hepan = 2,
//    [Description("推运盘")]
//    tuiyun = 3,
//}
//
//public static SortedList GetAstroType()
//{
//    return GetStatus(typeof(AstroType));
//}
//public static string GetAstroType(object v)
//{
//    return GetDescription(typeof(AstroType), v);
//}
//
//public enum AstroZuhe
//{
//    [Description("比较盘(comparison)")]
//    bijiao = 1,
//    [Description("组合盘(composite)")]
//    zuhe = 2,
//    [Description("时空中点盘(midpoint)")]
//    shikong = 3,
//    [Description("合并盘(synastry)")]
//    hebing = 4,
//}
//
//public static SortedList GetAstroZuhe()
//{
//    return GetStatus(typeof(AstroZuhe));
//}
//public static string GetAstroZuhe(object v)
//{
//    return GetDescription(typeof(AstroZuhe), v);
//}
//
//public enum AstroTuiyun
//{
//    [Description("行运VS本命(Transit)")]
//    xingyun = 1,
//    [Description("月亮次限法(365.25636)")]
//    cixian = 2,
//    [Description("月亮三限法(29.530588)")]
//    sanxian = 3,
//    [Description("月亮三限法(27.321582)")]
//    sanxian1 = 4,
//    [Description("太阳反照法(Solar Return)")]
//    rifanzhao = 5,
//    [Description("月亮反照法(Lunar Return)")]
//    yuefanzhao = 6,
//    [Description("太阳弧法(Solar Arc)")]
//    taiyanghu = 7,
//}
//
//public static SortedList GetAstroTuiyun()
//{
//    return GetStatus(typeof(AstroTuiyun));
//}
//public static string GetAstroTuiyun(object v)
//{
//    return GetDescription(typeof(AstroTuiyun), v);
//}
//
//public enum AstroStar
//{
//    [Description("太阳")]
//    Sun = 1,
//    [Description("月亮")]
//    Moo = 2,
//    [Description("水星")]
//    Mer = 3,
//    [Description("金星")]
//    Ven = 4,
//    [Description("火星")]
//    Mar = 5,
//    [Description("木星")]
//    Jup = 6,
//    [Description("土星")]
//    Sat = 7,
//    [Description("天王星")]
//    Ura = 8,
//    [Description("海王星")]
//    Nep = 9,
//    [Description("冥王星")]
//    Plu = 10,
//    [Description("凯龙星")]
//    Chi = 11,
//    [Description("谷神星")]
//    Cer = 12,
//    [Description("智神星")]
//    Pal = 13,
//    [Description("婚神星")]
//    Jun = 14,
//    [Description("灶神星")]
//    Ves = 15,
//    [Description("北交点")]
//    Nod = 16,
//    [Description("莉莉丝")]
//    Lil = 17,
//    [Description("福点")]
//    For = 18,
//    [Description("宿命点")]
//    Ver = 19,
//    [Description("东升点")]
//    Eas = 20,
//    [Description("上升点")]
//    Asc = 21,
//    [Description("二宫头")]
//    Second = 22,
//    [Description("三宫头")]
//    Third = 23,
//    [Description("天底")]
//    Nad = 24,
//    [Description("五宫头")]
//    Fifth = 25,
//    [Description("六宫头")]
//    Sixth = 26,
//    [Description("下降点")]
//    Des = 27,
//    [Description("八宫头")]
//    Eighth = 28,
//    [Description("九宫头")]
//    Ninth = 29,
//    [Description("中天")]
//    Mid = 30,
//    [Description("十一宫头")]
//    Eleventh = 31,
//    [Description("十二宫头")]
//    Twelveth = 32,
//    [Description("南交点")]
//    AntiNod = 33,
//}
//
//public static SortedList GetAstroStar()
//{
//    return GetStatus(typeof(AstroStar));
//}
//public static string GetAstroStar(object v)
//{
//    return GetDescription(typeof(AstroStar), v);
//}
//
//public enum Constellation
//{
//    [Description("白羊座")]
//    Ari = 1,
//    [Description("金牛座")]
//    Tau = 2,
//    [Description("双子座")]
//    Gem = 3,
//    [Description("巨蟹座")]
//    Can = 4,
//    [Description("狮子座")]
//    Leo = 5,
//    [Description("处女座")]
//    Vir = 6,
//    [Description("天秤座")]
//    Lib = 7,
//    [Description("天蝎座")]
//    Sco = 8,
//    [Description("射手座")]
//    Sag = 9,
//    [Description("摩羯座")]
//    Cap = 10,
//    [Description("水瓶座")]
//    Aqu = 11,
//    [Description("双鱼座")]
//    Pis = 12,
//    
//}
//
//public static SortedList GetConstellation()
//{
//    return GetStatus(typeof(Constellation));
//}
//public static string GetConstellation(object v)
//{
//    return GetDescription(typeof(Constellation), v);
//}
//
//public enum Element
//{
//    [Description("风")]
//    wind = 3,
//    [Description("火")]
//    fire = 1,
//    [Description("水")]
//    aqua = 4,
//    [Description("土")]
//    earth = 2,
//    
//    
//}
//
//public static SortedList GetElement()
//{
//    return GetStatus(typeof(Element));
//}
//public static string GetElement(object v)
//{
//    return GetDescription(typeof(Element), v);
//}
//
//public enum Phase
//{
//    [Description("合")]
//    he = 0,
//    [Description("刑")]
//    xing = 90,
//    [Description("拱")]
//    gong = 120,
//    [Description("冲")]
//    chong = 180,
//    [Description("半拱")]
//    bangong = 60,
//    
//}
//
//public static SortedList GetPhase()
//{
//    return GetStatus(typeof(Phase));
//}
//public static string GetPhase(object v)
//{
//    return GetDescription(typeof(Phase), v);
//}
//
//
//
//#endregion
//
//
#endif
