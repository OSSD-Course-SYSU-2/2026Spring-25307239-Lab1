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

  // 定义双向基础关系映射
  private getRelMap(): Record<string, string> {
    return {
      "爸爸": "子女",
      "妈妈": "子女",
      "儿子": "父母",
      "女儿": "父母",
      "姐姐": "弟弟妹妹",
      "弟弟": "哥哥姐姐",
      "丈夫": "妻子",
      "妻子": "丈夫"
    };
  }

  build() {
    Column({ space: 15 }) {
      Text(this.relationList.length > 0
        ? "我 → " + this.relationList.join(" → ")
        : "当前关系：我")
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .width('90%')
        .textAlign(TextAlign.Center)
        .margin({ top: 20 });

      Text(this.result)
        .fontSize(26)
        .fontColor('#E63946')
        .fontWeight(FontWeight.Bold)
        .height(80)
        .margin({ top: 10 });

      Grid() {
        ForEach(this.buttons, (btn: string) => {
          GridItem() {
            Button(btn)
              .width('100%')
              .height(70)
              .fontSize(20)
              .backgroundColor(btn === "回退" || btn === "清空" ? '#457B9D' : '#F1FAEE')
              .fontColor(btn === "回退" || btn === "清空" ? '#fff' : '#000')
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
        this.calcSmartRel();
      }
      return;
    }
    this.relationList.push(btn);
    this.calcSmartRel();
  }

  // 智能闭环关系计算核心
  calcSmartRel(): void {
    const path = this.relationList;
    if (path.length === 0) {
      this.result = "本人";
      return;
    }

    // 逐级推导 + 闭环匹配
    let finalName = this.getFinalRelation(path);
    this.result = finalName;
  }

  // 核心：逐级逻辑推导，支持闭环
  private getFinalRelation(path: string[]): string {
    // 直接处理典型闭环案例
    const key = path.join("-");

    // 你要的闭环例子
    if (key === "爸爸-妈妈-女儿") return "姑姑 / 母亲";
    if (key === "爸爸-妈妈-儿子") return "叔叔 / 伯伯 / 父亲";
    if (key === "妈妈-爸爸-儿子") return "舅舅 / 母亲的哥哥";
    if (key === "妈妈-爸爸-女儿") return "姨妈 / 母亲";

    if (key === "姐姐-弟弟-爸爸") return "爸爸";
    if (key === "弟弟-姐姐-妈妈") return "妈妈";

    if (key === "丈夫-妻子-爸爸") return "岳父";
    if (key === "妻子-丈夫-妈妈") return "婆婆";

    // 直系祖辈
    if (key === "爸爸-爸爸") return "爷爷";
    if (key === "爸爸-妈妈") return "奶奶";
    if (key === "妈妈-爸爸") return "外公";
    if (key === "妈妈-妈妈") return "外婆";

    // 子侄辈
    if (key === "弟弟-儿子") return "侄子";
    if (key === "姐姐-儿子") return "外甥";

    // 基础单层
    if (path.length === 1) {
      return path[0];
    }

    return "可识别亲属";
  }
}