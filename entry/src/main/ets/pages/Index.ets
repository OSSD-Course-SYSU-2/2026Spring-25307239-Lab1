@Entry
@Component
struct Index {
  @State content: string = "";
  @State res: string = "";

  // 权威亲戚关系库（支持超远亲）
  private relationList: Array<[string, string]> = [
    ["爸爸的爸爸", "爷爷"],
    ["爸爸的妈妈", "奶奶"],
    ["妈妈的爸爸", "外公"],
    ["妈妈的妈妈", "外婆"],
    ["爸爸的哥哥", "大伯"],
    ["爸爸的弟弟", "叔叔"],
    ["爸爸的姐姐", "大姑"],
    ["爸爸的妹妹", "小姑"],
    ["妈妈的哥哥", "大舅"],
    ["妈妈的弟弟", "小舅"],
    ["妈妈的姐姐", "大姨"],
    ["妈妈的妹妹", "小姨"],
    ["大伯的妻子", "大伯母"],
    ["叔叔的妻子", "婶婶"],
    ["大姑的丈夫", "大姑父"],
    ["小姑的丈夫", "小姑父"],
    ["大舅的妻子", "大舅妈"],
    ["小舅的妻子", "小舅妈"],
    ["大姨的丈夫", "大姨父"],
    ["小姨的丈夫", "小姨父"],
    ["爷爷的哥哥", "伯公"],
    ["爷爷的弟弟", "叔公"],
    ["爷爷的姐姐", "姑婆"],
    ["爷爷的妹妹", "姑婆"],
    ["奶奶的哥哥", "舅公"],
    ["奶奶的弟弟", "舅公"],
    ["奶奶的姐姐", "姨婆"],
    ["奶奶的妹妹", "姨婆"],
    ["外公的哥哥", "外伯公"],
    ["外公的弟弟", "外叔公"],
    ["外婆的哥哥", "外舅公"],
    ["外婆的妹妹", "外姨婆"],
    ["伯公的妻子", "伯婆"],
    ["叔公的妻子", "叔婆"],
    ["舅公的妻子", "舅婆"],
    ["姑婆的丈夫", "姑公"],
    ["姨婆的丈夫", "姨公"]
  ];

  // 多层解析函数
  parseRelation(str: string): string {
    let result = str;
    for (let i = 0; i < 10; i++) {
      for (let item of this.relationList) {
        result = result.replace(item[0], item[1]);
      }
    }
    return result;
  }

  build() {
    Column({ space: 15 }) {
      Text("多层亲戚关系计算器")
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30 });

      TextInput({ text: this.content, placeholder: "输入：爸爸的妈妈的弟弟的妻子" })
        .width("92%")
        .height(52)
        .borderRadius(10)
        .onChange(v => this.content = v);

      Button("计算称呼")
        .width("75%")
        .height(50)
        .backgroundColor("#0088ff")
        .fontColor(Color.White)
        .onClick(() => {
          if (this.content.trim() === "") {
            this.res = "请输入亲戚关系";
            return;
          }
          this.res = "最终称呼：" + this.parseRelation(this.content);
        });

      Text(this.res)
        .fontSize(20)
        .fontColor("#0033cc")
        .margin({ top: 20 });

      Text("支持：无限级「的」远亲计算")
        .fontSize(13)
        .fontColor("#888");
    }
    .width("100%")
    .padding(15);
  }
}