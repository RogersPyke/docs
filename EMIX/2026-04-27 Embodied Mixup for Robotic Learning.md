# 上周反馈
## 从数据孤岛的角度出发
当任务场景和本体有很大区别时，其数据分布存在巨大差异，造成数据孤岛
该现象不一定适用于同一本体和场景的任务数据
![image.png](https://raw.githubusercontent.com/Koorye/Images/master/20260413203631805.png)

# 动机
## [ICLR 2026] When would Vision-Proprioception Policies Fail in Robotic Manipulation?
作者单位：人大、北航

现有研究出现了完全相悖的实验结论：
- 正向结论：HPT 等工作证明，视觉 + 本体感受的融合策略能带来显著的性能提升
- 负向结论：Octo 等通用机器人策略工作发现，加入本体感受的策略，性能普遍比纯视觉策略更差

核心定义：

| 阶段类型                             | 核心特征                                         | 核心依赖模态                           |
| -------------------------------- | -------------------------------------------- | -------------------------------- |
| 运动一致阶段（motion-consistent phases） | 机器人执行持续、稳定的运动（如匀速向前移动、持续夹取），运动模式无切换          | 本体感受（提供精准的闭环运动控制）                |
| 运动转换阶段（motion-transition phases） | 机器人运动模式发生切换（如从移动转向目标定位、抓取、装配、姿态调整），需要精准的目标定位 | 视觉模态（提供目标物体的位置与环境信息，本体感受无目标相关信息） |

在不同阶段测试“视觉-本体”策略和“纯视觉”策略，发现：
- *运动保持阶段*：“视觉-本体”策略比“纯视觉”策略性能更好
- *运动过渡阶段*：“视觉-本体”策略对性能造成明显退化

![](https://raw.githubusercontent.com/Koorye/Images/master/20260427200048761.png)
**结论**：视觉 - 本体感受策略的视觉模态，在运动转换阶段完全没有发挥应有的作用，这是策略整体失效的直接原因

论文从行为克隆（BC）的训练优化框架出发，深挖了视觉模态被抑制的根本原因：
1. 运动转换阶段，视觉线索往往极其细微，仅存在像素级差异，学习难度高；而本体感受信号是低维和简洁的（如夹爪开合度、位姿变化），对损失下降的贡献更直接。
2. 模型为了快速降低训练损失，会天然地倾向于依赖更 “易用” 的本体感受信号，导致本体感受主导了整个优化过程，**严重抑制了视觉模态的特征学习**。
3. 这种抑制在运动一致阶段无负面影响，但在运动转换阶段，测试时目标初始位置是随机变化的，本体感受不包含目标物体的空间信息，策略无法通过视觉完成目标定位。

**方法**：GAP（Gradient Adjustment with Phase-guidance，相位引导的梯度调整），核心目标是实现视觉与本体感受的动态协同
1. *运动转换阶段估计*：预测每个时间步属于运动转换阶段的概率，为后续梯度调整提供细粒度的引导：
	1. 先通过**变点检测（CPD）算法**，基于运动方向的一致性，将整条轨迹分割为多个运动一致阶段，阶段之间的间隔即为运动转换区间；
	2. 引入**LSTM 时序网络**，输入本体感受的时序差分 $\Delta s_i$，预测每个时间步属于运动转换阶段的概率 $\rho$（取值 0~1，值越高，该时间步越接近运动转换阶段）。
 2. *模态协同的梯度调整*：通过细粒度的梯度调制，避免本体感受在运动转换阶段主导优化：
	1. 梯度更新公式：$\omega _{s}^{j+1}=\omega _{s}^{j}-\lambda \cdot (1-\rho )\cdot \eta \nabla \omega _{s}^{j}\mathcal {L}_{BC}$
	2. 核心逻辑：$\rho$ 越高（越接近运动转换阶段），本体感受的反向梯度幅度就被削弱得越多，迫使模型在该阶段重点学习视觉模态的特征。

![image.png](https://raw.githubusercontent.com/Koorye/Images/master/20260427200621987.png)

**主实验结果**：仿真和真实环境统一的性能提升
![image.png](https://raw.githubusercontent.com/Koorye/Images/master/20260427201628523.png)

**消融实验**：适用于不同的视觉+姿态混合方式，拼接、求和、FiLM
![image.png](https://raw.githubusercontent.com/Koorye/Images/master/20260427202341684.png)

**逐阶段分析**：用 GAP 优化后的策略替换动作，运动转换阶段的成功率下降几乎完全消失，直接证明 GAP 有效提升了视觉模态的利用率
![image.png](https://raw.githubusercontent.com/Koorye/Images/master/20260427201725002.png)

**结论**：视觉 - 本体感受策略的失效，根源在于**运动转换阶段，简洁的本体感受信号主导了模型优化，严重抑制了视觉模态的学习**，导致策略无法完成目标定位，泛化性崩盘
**本文的解决思路**：通过强行抑制本体感受梯度，迫使模型在运动转换阶段关注视觉信息

**限制**：GAP 仅在训练时抑制本体的梯度幅度，没有解决“模型为什么不想学视觉”的底层问题，本质原因是数据分布的单一性：受限于机器人轨迹数量和多样性，其数据分布中的动作与姿态呈现高度相关性，与视觉则存在较大差异

**进一步的想法**：==能否设计一种数据增强方法，让模型在关键时刻学习多峰，使得学习更容易？==

## Mixup 
传统的mixup方法：
1. 随机采样两对图像-文本对：$(v_1,t_1),(v_2,t_2)$
2. 线性叠加这两张图像：$v=0.5v_1+0.5v_2$
3. 拼接这两个文本：$t=[t1;t2]$
4. 将$(v,t)$作为新增训练样本

![image.png](https://raw.githubusercontent.com/Koorye/Images/master/20260413204822864.png)
> MixGen: A New Multi-Modal Data Augmentation. WACV Workshop 2023. 

Mixup无法直接迁移到具身领域：**物理语义冲突，** 随机混合两张位姿迥异的图片（如“抓取”与“放置”）会产生视觉上的物理矛盾（如手臂重影、物体悬空）

![image.png](https://raw.githubusercontent.com/Koorye/Images/master/20260413204613082.png)
# 方法：Embodied Mixup
**核心定义**：本体姿态歧义节点——不同轨迹之间存在交点，这些交点的本体姿态高度相似，对应的后续动作模式却完全不同
**结果**：此时本体信息完全失效，必须依赖视觉输入区分动作
**思路**：只有在这些节点强制模型学习视觉引导的多峰动作分布，才能从根源上打破本体依赖性

## 基于位姿一致性的图像拼贴
- **检索机制：** 建立基于末端执行器（End-effector）6D 位姿的索引表 $\mathcal{T}$。对于锚点样本 $(o, a, s)$，寻找满足 $\|s - s'\| < \epsilon$ 的近邻样本 $(o', a', s')$。
- **图像合成：** $o^{mix} = \alpha o + (1-\alpha) o'$。
    - _优势：_ 由于机器人手臂在两张图中位置几乎重合，叠加后的 $o^{mix}$ 不会出现严重的手臂重影，而环境特征（背景、物体颜色）则通过插值实现了平滑演变。

## 动作概率预测
### 适用于自回归 Policy (Autoregressive / Discrete Tokenization)
对于类似 RT-2 或 OpenVLA 这种将动作离散化为 Token 的模型，Mixup 转化为**软标签回归（Soft-target Supervision）**
- **输入端：** 图像执行线性插值 $x_{mix} = \alpha x_1 + (1-\alpha) x_2$；语言指令进行拼接或重写
- **输出端：** 不再要求模型预测唯一的动作 Token，而是计算两个原始动作 $a_1, a_2$ 对应 Token 的分布：$$P(a_{target}) = \alpha \cdot \text{OneHot}(a_1) + (1-\alpha) \cdot \text{OneHot}(a_2)$$
- **损失函数：** 使用交叉熵损失（Cross-Entropy）计算预测分布与上述混合分布之间的差异，起到类似“标签平滑”的作用。
![image.png](https://raw.githubusercontent.com/Koorye/Images/master/20260413210801421.png)

### 适用于 Diffusion Policy
由于 Diffusion Policy 预测的是分数场（Score Field），不能直接对预测值做线性平均，否则会退化为单峰均值。
- **策略一：加权分数匹配 (Weighted Score Matching)**。在去噪过程中，针对同一个混合输入 $x_{mix}$，计算其相对于两个目标的梯度合力：$$\mathcal{L}_{diff} = \alpha \| \epsilon_1 - \epsilon_\theta(a_{k,1}, k, x_{mix}) \|^2 + (1-\alpha) \| \epsilon_2 - \epsilon_\theta(a_{k,2}, k, x_{mix}) \|^2$$
- **策略二：多峰轨迹生成**。推理时，由于模型在训练中看到了混合特征，Diffusion过程会自适应的向两个目标靠近。这允许模型在处理模糊指令时，通过随机采样从多个有效路径中选择其一，而非机械地取中间值
![image.png](https://raw.githubusercontent.com/Koorye/Images/master/20260413210751402.png)

# 实验设计
**模型栈：**
- **Low-level Control:** ACT, Diffusion Policy (验证细粒度动作控制)
- **Generalist VLA:** $\pi_0$, OpenVLA (验证跨任务理解能力)

**对比方法**：无增强学习 / Naive Mixup / Embodied-Mixup

**测试维度**：
1. **域内泛化 (In-domain)：** 在同一场景内进行混合，测试方法对模型性能的提升
2. **跨任务泛化 (Cross-scene)：** 混合不同任务中位姿一致的动作，测试是否能增强跨任务泛化能力
3. **组合逻辑泛化 (Compositional Zero-shot)：** 训练集：(A: 萝卜放盘子), (B: 饼干放毛巾)，测试集：(C: 萝卜放毛巾)

**Benchmark**：Maniskill
![image.png](https://raw.githubusercontent.com/Koorye/Images/master/20260427211336327.png)

# 可能的扩展
**语义相似度辅助：** 在进行位姿搜索时，建议加入一个轻量级的 CLIP 图像特征距离约束，防止将完全无关的场景（如“切菜”与“擦地”）混合在一起，导致视觉特征过度离散
**自适应权重选择**：针对不同任务，自适应选取合适的插值权重，使数据更好填充流形空间，促进特征连续性