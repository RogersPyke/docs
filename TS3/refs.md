# TS3 统一参考文献

基于 TS3.bib 整理。每篇文献简述对本研究的参考价值，非照抄原文。
标记 🏷️ 的条目为本研究核心论点的直接证据或方法论基石。

---

## 分类索引

| 分类 | 编号 | 文献 |
|------|------|------|
| A. 时序基础模型——数据策略现状与缺陷 | 1–5 | Sundial, TATO, TIME, Chronos, Timer-S1 |
| B. 课程学习 | 6–8 | Contrastive CL, Dual-Criterion CL, GTT |
| C. 数据选择与多样性 | 9–14 | Multi-Actor, DSIR, GraNd/EL2N, Training Diet, Density/Ask-LLM, QuaDMix |
| D. 时序数据估值与质量评估 | 15–16 | Temporal-Decay Shapley, Rating Quality |
| E. 时序基础模型补充证据 | 17–18 | TimesFM, PatchTST |
| F. 综述与背景 | 19–20 | KDD Survey, TPAMI Survey |

---

## A. 时序基础模型——数据策略现状与缺陷

### [1] 🏷️ Sundial: A Family of Highly Capable Time Series Foundation Models

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2502.00816 / doi:10.48550/arXiv.2502.00816 |
| **来源** | arXiv 2025 (v4: 2026年5月) |
| **作者** | Liu, Qin, Shi, Chen, Yang, Huang, Wang, Long (THUMLab, Tsinghua) |

原生连续值时序基础模型，Patch-Transformer-Flow三段式架构，TimeFlow Loss实现概率预测。预训练语料TimeBench 1032B时间点，ERA5气象数据占84.66%。多样性仅以"领域×频率"保障。

**参考价值**：当前TSFM数据策略的典型证据——完全基于业务背景多样性，无信号结构多样性，无课程学习。本研究直接针对此缺陷。

---

### [2] TATO: Adapt Data to Model

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2603.00629 |
| **来源** | arXiv 2026 |
| **作者** | Qiu, Cen, Pei, Wang, Wang (Tsinghua) |

冻结预训练模型，仅优化数据预处理流水线（切片、归一化、异常修正）的超参数组合。TPE贝叶斯优化搜索方案空间，Pareto前沿选取最优方案，2分钟内完成，MSE最高降低65.4%。

**参考价值**：证明数据层优化可大幅提升TSFM性能，支撑本研究"不改模型、改数据调度"的data-centric定位。但TATO优化的是预处理超参数而非训练数据选择策略。

---

### [3] 🏷️ It's TIME: Towards the Next Generation of Time Series Forecasting Benchmarks

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2602.12147 |
| **来源** | arXiv 2026 |
| **作者** | Qiao, Pan, Wang, Zhukova, Liu, Jiang, Wen, Long, Jin, Liu |

提出7维tsfeatures分类方案（趋势强度、趋势线性度、季节性强度、季节性相关、残差ACF-1、谱熵、平稳性），按模式而非领域评估TSFM。核心发现：(1)高复杂度序列是"性能均衡器"，低复杂度序列放大模型差异；(2)结构性是领域差异的根本。

**参考价值**：(1) 7维tsfeatures与本研究7维结构空间高度对应，佐证特征选取的合理性；(2) "结构性而非领域性"的主张与本核心叙事完全一致；(3) 其模式层级评估可借鉴用于本研究的实验评估设计。

---

### [4] 🏷️ Chronos: Learning the Language of Time Series

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2403.07815 / doi:10.48550/arXiv.2403.07815 |
| **来源** | ICLR 2024 |
| **作者** | Ansari, Stella, Turkmen, Zhang, Mercado, Shen, Shchur, Rangapuram, Arango, Kapoor, Zschiegner, Maddix, Wang, Mahoney, Torkkola, Wilson, Bohlke-Schneider, Wang (AWS AI Labs) |

时序token化+语言模型架构预训练（T5家族，20M–710M参数）。数据多样性仅依赖领域覆盖+TSMixup/KernelSynth增强，无信号特征多样性，无课程学习。

**参考价值**：主流TSFM数据策略缺陷的典型证据——多样性完全由业务领域覆盖+合成增强保障，未用信号特征指导数据选择。

---

### [5] 🏷️ Timer-S1: A Billion-Scale Time Series Foundation Model with Serial Scaling

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2603.04791 / doi:10.48550/arXiv.2603.04791 |
| **来源** | arXiv 2026 |
| **作者** | Liu, Su, Wang, Zhang, Liu, Wang, Ye, Xiang, Wang, Long (Tsinghua & ByteDance) |

8.3B MoE模型（0.75B激活参数），Serial-Token Prediction训练目标。唯一显式计算信号特征（ADF统计量+谱熵）的TSFM，但仅用于事后评估，未指导数据选择或课程学习。两阶段训练基于预测步长而非信号特征。ARIMA变量筛选是唯一基于信号特征的数据筛选，但仅用自回归性一个维度。

**参考价值**：本研究最直接的前驱论文——证明信号特征可计算可评估，但未走到"用信号特征做数据选择和课程学习"这一步。本研究填补这一空白。

---

## B. 课程学习

### [6] 🏷️ Enabling TSFM for Building Energy Forecasting via Contrastive Curriculum Learning

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2412.17285 |
| **来源** | arXiv 2024 |
| **作者** | Liang, Deng, Xie, He, Wang |

对比课程学习框架，用对比学习将模拟数据难度传递到真实数据（正样本=预测误差相近、负样本=预测误差相差大），实现从易到难的训练调度。零样本/少样本性能提升14.6%。

**参考价值**：目前与TSFM课程学习最直接相关的工作。关键局限：(1)难度仅一维（预测误差），不基于多维信号特征；(2)仅在建筑能源单场景验证。本研究将CL从一维难度排序升级为7维结构空间膨胀。

---

### [7] Dual-Criterion Curriculum Learning: Application to Temporal Data

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2603.23573 |
| **来源** | arXiv 2026 |
| **作者** | Abel, Campagne, Benloughmari, Kalogeratos |

双准则课程学习：loss（模型视角）+ density（数据视角）。密度指标识别"因稀少而假难"的样本，防止训练初期被异常值带偏。在电力、流感、天气等多数据集验证有效。

**参考价值**：density维度的引入与本研究"结构空间均布采样"理念一致——稀有结构模式不应被忽视。本研究进一步将density从单维度扩展到7维结构空间的饱和度逆概率采样$P(\text{Grid}_k) \propto 1/(c_k + \epsilon)$。

---

### [8] 🏷️ GTT: Only the Curve Shape Matters

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2402.07570 / doi:10.48550/arXiv.2402.07570 |
| **来源** | arXiv 2024 |
| **作者** | Feng, Huang, Krompass |

曲线形状预测范式（General Time Transformer），200M样本预训练。将多变量时序表述为"曲线形状"序列，基于过去形状预测下一段形状。曲线形状复杂度天然形成隐式课程学习（简单趋势→平滑形状→复杂季节性）。观察到Scaling Law在零样本多变量预测中同样成立。

**参考价值**：GTT观察到"曲线形状复杂度→学习难度"的关系，为本研究的"信号特征→难度"提供直觉支撑。但GTT的CL是被动涌现的，本研究是主动设计的7维结构空间膨胀。

---

## C. 数据选择与多样性

### [9] Multi-Actor Data Selection via Importance Resampling

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2410.08102 |
| **来源** | arXiv 2024 |
| **作者** | Bai, Yang, Wong, Sun, Peng, Zhuang, Zhang, Wu, Qiu, Zhang, Yuan, He |

三Actor（质量、主题、领域）协同数据筛选，影响函数计算单样本对参考任务的贡献作为奖励信号，强化学习动态调整各Actor权重。平均提升10.5%，计算量降至基线的1/2–1/7。

**参考价值**：多维度协同优化数据选择的思想与本研究7维结构空间协同采样异曲同工。但(1)维度是业务属性而非信号特征；(2)需要模型反馈计算影响函数，非模型无关。

---

### [10] DSIR: Data Selection via Importance Resampling

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2302.03169 / doi:10.48550/arXiv.2302.03169 |
| **来源** | NeurIPS 2023 |
| **作者** | Xie, Santurkar, Ma, Liang (Stanford) |

基于哈希n-gram的重要性重采样，从全量数据中选取最像目标分布（如Wikipedia+Books）的子集。KL Reduction指标可预测数据选择质量，4.5小时处理1亿文档，GLUE提升2–2.5%。

**参考价值**：重要性采样+分布匹配的范式参考。但DSIR匹配的是"目标分布"而非"结构空间覆盖度"——本研究目标是空间均布而非分布匹配。LSH降维思想可参考用于高维结构空间近似。

---

### [11] GraNd & EL2N: Deep Learning on a Data Diet

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2107.07075 |
| **来源** | arXiv 2021 |
| **作者** | Paul, Ganguli, Dziugaite |

提出GraNd（梯度范数）和EL2N（误差L2范数）两种训练早期可计算的样本难度评分。训练几个epoch即可识别关键样本，CIFAR10上剔除50%数据仍提升准确率。

**参考价值**：证明样本难度在训练早期可见，支撑"课程学习可基于训练初期信号设计"的假设。但本研究用数学信号特征代替模型反馈，无需训练即可排序——这是模型无关的关键优势。

---

### [12] Optimizing the Training Diet: Data Mixture Search for Robust TS Forecasting

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2512.11546 |
| **来源** | arXiv 2025 |
| **作者** | Pennino, Gabbrielli |

k-means聚类将时序数据分为36箱，Optuna搜索各箱采样比。PMSU数据集上数据量减半但MSE从1.70降至1.37（19.4%提升）。丢弃的数据多为静默信号和噪声。

**参考价值**：聚类分箱+超参数优化采样比的思想与本研究"结构空间分箱+膨胀采样"高度相似。关键区别：(1)用k-means而非结构特征分箱——无法保证分箱的物理语义；(2)用黑盒优化而非理论驱动的膨胀策略；(3)仅在PMSM单数据集验证。

---

### [13] 🏷️ How to Train Data-Efficient LLMs: Ask-LLM & Density Sampling

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2402.09668 / doi:10.48550/arXiv.2402.09668 |
| **来源** | arXiv 2024 (Google DeepMind) |
| **作者** | Sachdeva, Coleman, Kang, Ni, Hong, Chi, Caverlee, McAuley, Cheng |

Density方法：LSH随机投影+特征空间密度估计，逆概率采样$P(x) \propto 1/S(x)$确保低密度区域优先，80MB内存处理3.6亿数据。Ask-LLM：用LLM零样本评估数据质量，拒绝90%数据仍超越全量训练。

**参考价值**：(1) 逆概率采样与本研究饱和度逆概率采样$P(\text{Grid}_k) \propto 1/(c_k + \epsilon)$理念一致——均确保罕见样本被优先覆盖；(2) LSH降维+两遍扫描的工程思路可参考；(3) 但Density匹配"均匀分布"而非"课程膨胀"——本研究同时控制时间和空间两个维度。

---

### [14] QuaDMix: Quality-Diversity Balanced Data Selection for Efficient LLM Pretraining

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2504.16511 / doi:10.48550/ARXIV.2504.16511 |
| **来源** | arXiv 2025 (ByteDance) |
| **作者** | Liu, Zhou, Liu, Yu, Zhang, Lin, Yu, Zhang, Zhou, Wang, Cao |

统一质量-多样性权衡框架，参数化Sigmoid函数$S(\bar{r})$决定每个文档的采样概率（含质量阈值$\omega$、下降坡度$\lambda$、缩放系数$\eta$、多样性保底$\epsilon$）。代理模型+LightGBM搜索最优参数，平均提升7.2%。

**参考价值**：(1) 质量-多样性联合优化的范式参考；(2) Sigmoid采样函数与本研究膨胀边界退火有数学对应关系；(3) 但QuaDMix的维度是业务属性（领域+质量），而非7维信号结构特征；(4) 多样性保底$\epsilon$与本研究防除零常数$\epsilon$的数学形式一致。

---

## D. 时序数据估值与质量评估

### [15] Temporal-Decay Shapley: A Time-Aware Data Valuation Framework

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2605.08153 / doi:10.48550/arXiv.2605.08153 |
| **来源** | ICLR 2025 |
| **作者** | Pang, Mi, Chen |

时序数据估值框架，时间衰减Shapley值+多尺度融合。TDS引入指数衰减权重，改进版采用幂指数衰减适应非线性时间漂移，MS-TDS多尺度融合兼顾短期热点和长期基础样本价值。

**参考价值**：数据估值的理论基础，但其维度是时间衰减而非信号结构特征。本研究将估值维度从"时间重要性"扩展到"结构空间覆盖度"。

---

### [16] Rating Quality of Diverse Time Series Data by Meta-learning from LLM Judgment

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2506.01290 / doi:10.48550/arXiv.2506.01290 |
| **来源** | ICLR 2026 |
| **作者** | Wu, Li, Feng, Ye, Lou, Ng (A*STAR, NUS) |

TSRating框架：利用LLM判断时序数据质量，元学习训练TSRater跨域通用评分函数。9个领域收集质量比较对，signSGD提升训练效率。在11个基准+3个时序任务上验证。

**参考价值**：数据质量评分→数据选择的范式参考。但其评分维度是LLM判断的"质量"，而非数学信号特征的结构覆盖度。

---

## E. 时序基础模型补充证据

### [17] TimesFM: A Decoder-Only Foundation Model for Time-Series Forecasting

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2310.10688 / doi:10.48550/arXiv.2310.10688 |
| **来源** | arXiv 2024 (Google Research) |
| **作者** | Das, Kong, Sen, Zhou |

200M参数decoder-only时序基础模型。Wiki Pageviews占约95%数据，严重偏向单一领域。合成数据含ARMA/季节/趋势但未用这些特征做数据选择。输出patch长度大于输入patch长度减少自回归步数。无课程学习。

**参考价值**：数据配比严重偏向自然可获得性的典型证据。

---

### [18] PatchTST: A Time Series is Worth 64 Words

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2211.14730 / doi:10.48550/arXiv.2211.14730 |
| **来源** | ICLR 2023 |
| **作者** | Nie, Nguyen, Sinthong, Kalagnanam (IBM Research) |

Patching范式开创者，通道独立建模。监督学习模型（非预训练），6个标准基准数据集（ETTh1/2、ETTm1/2、Weather、Electricity、Traffic、ILI）在信号特征空间高度集中（均呈强周期模式），缺乏高非平稳、高噪声覆盖。附录A.4探索了预训练版本但未详细讨论数据选择策略。

**参考价值**：(1) 标准基准结构单一性的证据；(2) 重要实验Baseline。

---

## F. 时序下游适配参考

### TimeRFT: Stimulating Generalizable TS Forecasting for TSFMs via Reinforcement Finetuning

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2605.00015 / doi:10.48550/arXiv.2605.00015 |
| **来源** | arXiv 2026 |
| **作者** | Li, Chen, Zhu, Pan, Guo, Huang, Xiong |

基于预测难度的数据选择+强化学习微调。预测质量时间奖励+难度导向数据选择。难度适中且泛化性强的样本优先。

**参考价值**：证明难度导向数据选择对TSFM有益。但(1)依赖模型反馈（model-dependent），不适用预训练阶段；(2)用于微调而非预训练。本研究用数学信号特征替代模型反馈，使CL可在预训练阶段使用。

---

## G. 综述与背景

### [19] Foundation Models for Time Series Analysis: A Tutorial and Survey

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2403.14735v3 / doi:10.1145/3637528.3671451 |
| **来源** | KDD 2024 |
| **作者** | Liang, Wen, Nie, Jiang, Jin, Song, Pan, Wen |

全面综述TSFM的架构（Transformer/Non-Transformer/Diffusion）、预训练技术（监督/自监督）、适应方法（零样本/Prompting/Patching/微调）和数据模态。

**参考价值**：背景知识。数据类型分类（标准时序/空间时序/轨迹/事件）和适应方法表为本研究提供术语框架。信息量不如TPAMI综述。

---

### [20] Deep Time Series Models: A Comprehensive Survey and Benchmark

| 字段 | 内容 |
|------|------|
| **链接 / DOI** | arXiv:2407.13278 / doi:10.48550/arXiv.2407.13278 |
| **来源** | TPAMI 2026 |
| **作者** | Wang, Wu, Dong, Liu, Wang, Long, Wang (THUMLab, Tsinghua) |

全面综述时序模型基础模块（平稳化、分解→级数展开/基扩展/矩阵分解、频域→表示/建模、注意力机制）和架构（MLP/RNN/CNN/GNN/Transformer），含TSLib 41模型+30数据集基准。

**参考价值**：背景知识。时序特征工程（STL分解、频域分析、平稳性检验）的数学基础与本研究7维结构特征的计算方法直接相关。特别是：
- STL分解→趋势强度$S_{\text{trend}}$、周期强度$S_{\text{period}}$、噪声强度$S_{\text{noise}}$的计算基础
- 频域分析→谱熵（Complexity）的理解基础
- 自相关→记忆强度$S_{\text{memory}}$的数学来源
- 矩阵分解→跨变量耦合度$S_{\text{coupling}}$的理论背景

---

## 引用格式速查

| 编号 | 引用键 | 引用格式 |
|------|--------|---------|
| 1 | liu_sundial_2025 | Liu et al., 2025 |
| 2 | qiu_adapt_2026 | Qiu et al., 2026 |
| 3 | qiao_its_2026 | Qiao et al., 2026 |
| 4 | ansari_chronos_2024 | Ansari et al., 2024 |
| 5 | liu_timer-s1_2026 | Liu et al., 2026 |
| 6 | liang_enabling_2024 | Liang et al., 2024 |
| 7 | abel_dual-criterion_2026 | Abel et al., 2026 |
| 8 | feng_only_2024 | Feng et al., 2024 |
| 9 | bai_efficient_2024 | Bai et al., 2024 |
| 10 | xie_data_2023 | Xie et al., 2023 |
| 11 | paul_deep_2021 | Paul et al., 2021 |
| 12 | pennino_optimizing_2025 | Pennino & Gabbrielli, 2025 |
| 13 | sachdeva_how_2024 | Sachdeva et al., 2024 |
| 14 | liu_quadmix_2025 | Liu et al., 2025 |
| 15 | pang_temporal-decay_2026 | Pang et al., 2026 |
| 16 | wu_rating_2026 | Wu et al., 2026 |
| 17 | das_decoder-only_2024 | Das et al., 2024 |
| 18 | nie_time_2023 | Nie et al., 2023 |
| 19 | liang_foundation_2024 | Liang et al., 2024 |
| 20 | wang_deep_2026 | Wang et al., 2026 |