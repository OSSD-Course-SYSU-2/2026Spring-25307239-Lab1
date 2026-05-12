@Entry
@Component
struct RelativeCalculator {
  @State relationList: string[] = [];
  @State result: string = "请点击按钮开始计算";

  private readonly buttons: string[] = [
    "爸爸", "妈妈", "姐姐", "弟弟",
    "儿子", "女儿", "妻子", "丈夫",
    "回退", "清空"
  ];

  build() {
    Column({ space: 15 }) {
      // 显示当前关系链
      Text(this.relationList.length > 0
        ? "我 → " + this.relationList.join(" → ")
        : "当前关系：我")
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .width('90%')
        .textAlign(TextAlign.Center)
        .margin({ top: 20 });

      // 显示计算结果
      Text(this.result)
        .fontSize(28)
        .fontColor('#E63946')
        .fontWeight(FontWeight.Bold)
        .height(80)
        .margin({ top: 10 });

      // 按键网格
      Grid() {
        ForEach(this.buttons, (btn: string) => {
          GridItem() {
            Button(btn)
              .width('100%')
              .height(70)
              .fontSize(20)
              .backgroundColor(
                btn === "回退" || btn === "清空" ? '#457B9D' : '#F1FAEE'
              )
              .fontColor(
                btn === "回退" || btn === "清空" ? '#fff' : '#000'
              )
              .onClick(() => this.onButtonClick(btn))
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .width('95%')
      .margin({ top: 10 });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F9FA')
    .padding(10);
  }

  onButtonClick(btn: string): void {
    if (btn === "清空") {
      this.relationList = [];
      this.result = "请点击按钮开始计算";
      return;
    }
    if (btn === "回退") {
      if (this.relationList.length > 0) {
        this.relationList.pop();
        this.computeRelation();
      }
      return;
    }
    this.relationList.push(btn);
    this.computeRelation();
  }

  computeRelation(): void {
    const path = this.relationList;
    if (path.length === 0) {
      this.result = "本人";
      return;
    }

    const key = path.join("-");
    let res = "可识别亲属";

    // 基础关系
    if (key === "爸爸") res = "父亲";
    else if (key === "妈妈") res = "母亲";
    else if (key === "姐姐") res = "姐姐";
    else if (key === "弟弟") res = "弟弟";
    else if (key === "儿子") res = "儿子";
    else if (key === "女儿") res = "女儿";
    else if (key === "妻子") res = "妻子";
    else if (key === "丈夫") res = "丈夫";

    // 关键闭环关系
    else if (key === "妈妈-丈夫") res = "父亲";
    else if (key === "爸爸-妻子") res = "母亲";
    else if (key === "姐姐-弟弟") res = "弟弟/哥哥";
    else if (key === "弟弟-姐姐") res = "姐姐/妹妹";
    else if (key === "儿子-父亲") res = "父亲/母亲";
    else if (key === "女儿-母亲") res = "母亲/父亲";

    // 祖辈关系
    else if (key === "爸爸-爸爸") res = "爷爷";
    else if (key === "爸爸-妈妈") res = "奶奶";
    else if (key === "妈妈-爸爸") res = "外公";
    else if (key === "妈妈-妈妈") res = "外婆";
    else if (key === "爸爸-爸爸-爸爸") res = "曾祖父";
    else if (key === "爸爸-爸爸-爸爸-爸爸") res = "高祖父";

    // 旁系亲戚
    else if (key === "爸爸-弟弟") res = "叔叔/伯伯";
    else if (key === "爸爸-姐姐") res = "姑姑";
    else if (key === "妈妈-弟弟") res = "舅舅";
    else if (key === "妈妈-姐姐") res = "姨妈";

    // 姻亲
    else if (key === "丈夫-爸爸") res = "公公";
    else if (key === "丈夫-妈妈") res = "婆婆";
    else if (key === "妻子-爸爸") res = "岳父";
    else if (key === "妻子-妈妈") res = "岳母";

    this.result = res;
  }
}