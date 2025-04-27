# Mephistroth 按键禁用助手（乌龟服专用）

## 作者
果盘杀手, 二狗子 - 天空之城（乌龟拉风服务器）

## 支持版本

- 魔兽世界怀旧服（乌龟服）客户端 1.12.x

## 简介

本插件专为魔兽世界乌龟服团队副本设计，在BOSS Mephistroth施放“Shackles of the Legion!”技能时，自动禁用WASD及方向键等常用移动按键，防止误操作。7秒后自动恢复原有按键绑定，无需手动干预。

## 功能特性

- 自动检测BOSS喊话“Mephistroth begins to cast Shackles of the Legion!”。
- 检测到后自动禁用W、A、S、D、Q、E及方向键等移动按键。
- 7秒后自动恢复所有原始按键绑定。
- 无需配置，安装即用。
- 不影响其他插件和按键设置，安全恢复原有绑定。

## 安装方法

1. 下载 zip 格式文件  
   [下载地址](https://github.com/Zhaoxinak/DT_Mephistroth)
2. 解压 `DT_Mephistroth-main.zip` 到 `Interface/AddOns/`
3. 重命名文件夹 `DT_Mephistroth-main` 为 `DT_Mephistroth`
4. 启动游戏并在角色选择界面勾选本插件

## 使用方法

- 插件自动运行，无需命令或界面操作。
- 当BOSS喊话出现时，插件会自动禁用相关按键，7秒后恢复。
- 无FuBar、命令行或图形界面依赖。

## 常见问题

- **插件无反应/报错？**  
  请确认插件已正确安装于 `Interface/AddOns/DT_Mephistroth` 文件夹下。
- **按键未被禁用？**  
  请确保BOSS喊话内容与插件内置检测一致（如有本地化差异请反馈）。
- **禁用后未恢复？**  
  正常情况下7秒后会自动恢复，如遇特殊情况可尝试重载界面（/reload）。
- **支持其他BOSS或喊话？**  
  当前仅支持Mephistroth的特定喊话，如需扩展请联系作者。

## 更新日志

#### 1.0 版本

- 首次发布，支持自动禁用/恢复WASD及方向键。

---

如有建议或问题欢迎反馈至 [项目主页](https://github.com/Zhaoxinak/DT_Mephistroth)  
也可通过乌龟服游戏内邮件联系“果盘杀手”或“二狗子”。
