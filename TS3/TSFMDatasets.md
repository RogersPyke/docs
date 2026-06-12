# 时序基础模型大规模开放数据集调研

> 调研范围：用于训练当前最热门时序基础模型（TSFM）的大规模开放数据集
> 整理时间：2026-06-12 (updated)
> 数据来源：基于知识库文档（TS3 论文、Chronos、Sundial、Timer-S1 等）+ 网络补充检索

---

## 数据集总览表

| # | 数据集名称 | 热门程度 & 论据 | 可获取程度 | 获取途径 & URL | 被哪些基础模型用于训练 | 发布时间 / 最近更新 |
|---|-----------|--------------|---------|--------------|-------------------|-----------------|
| 1 | **UTSD / TimeBench** | 极高 -- Sundial 和 Timer-S1 的核心训练集，1 万亿时间点规模，当前 TSFM 领域规模最大的数据集；THUMLab 清华团队开源 | 完全开放 | HuggingFace: <https://huggingface.co/datasets/thuml/UTSD> 或 GitHub: <https://github.com/thuml/TimeBench> | Sundial (THUMLab), Timer-S1 (THUMLab + ByteDance) | 2025.02 (Sundial 论文) / 2026.03 (Timer-S1 论文更新) |
| 2 | **ERA5 Reanalysis** | 极高 -- 气象领域最大规模公开数据集；Chronos、Sundial、Timer-S1 均大量使用；TimeBench 的 84.66% 由 ERA5 构成 | 完全开放 | ECMWF: <https://cds.climate.copernicus.eu/> 或 AWS Open Data: <https://registry.opendata.aws/ecmwf-era5/> | Chronos (AWS), Sundial, Timer-S1, TimesFM (部分) | 1950至今（持续更新） |
| 3 | **Chronos Pretraining Data** | 极高 -- Chronos 论文明确使用，来自 Kaggle/UCI/Monash 等公开集合，附 GP 合成数据；ICLR 2024 论文，42 数据集 benchmark，零样本 SOTA | 完全开放 | HuggingFace: <https://huggingface.co/datasets/autogluon/chronos_datasets> (67 subsets) 或 GitHub: <https://github.com/amazon-research/chronos> | Chronos (AWS AI Labs) | 2024.03 (ICLR 2024) |
| 4 | **TimesFM Pretraining Corpus** | 极高 -- Google Research 发布；100M 参数 scale；Wiki Pageviews 为主（约 95%），混合其他公开数据；2024 年发布后刷新多项基准 | 完全开放 | GitHub: <https://github.com/google-research/timesfm> （含数据说明） | TimesFM (Google Research) | 2024.02 (ICML 2024 同期) |
| 5 | **M4 Competition Dataset** | 高 -- forecasting 领域标杆竞赛数据，10 万条序列，覆盖 6 大领域；几乎所有时序论文均做 M4 评估；深度学习模型 baselines 必比 | 完全开放 | Kaggle: <https://www.kaggle.com/competitions/m5-forecasting-accuracy> 或 M4 repo: <https://github.com/Mcompetitions/M4-methods> | （主要用于评估，Chronos 等预训练模型在 M4 上做零样本评测） | M4: 2018 / M5: 2020 |
| 6 | **Monash Time Series Archive** | 高 -- 30+ 时序数据集统一格式整理，覆盖能源、交通、医疗、金融等；被 PatchTST 等模型直接用于训练；ECUE 2022 | 完全开放 | HuggingFace: <https://huggingface.co/datasets/Monash-University/monash_tsf> (30+ subsets, ~577MB) 或 官网: <https://forecastingdata.org/> | PatchTST (监督训练), 多个 TSFM 评估基准 | 2022 (ECUE 2022) |
| 7 | **ETT (Electricity Transformer Temperature)** | 高 -- 中国电网 ETT 数据；ETTh1/ETTh2/ETTm1/ETTm2 四个子集；LongForecasting 论文发起的基准，被 PatchTST/Informer 等广泛使用；部分版本数据量较小 | 完全开放 | GitHub: <https://github.com/zhouhaoyi/ETDataset> | PatchTST, LTSF-Linear 及多种监督学习基线 | 2021 (IJCAI 论文) |
| 8 | **Wikipedia Pageviews** | 高 -- Wikipedia 官方公开的页面访问量数据；TimesFM 训练数据主体（约 95%）；Chronos 等模型也使用；覆盖多语言、多主题 | 完全开放 | 官方: <https://dumps.wikimedia.org/other/pageview_history/> 或 Google Cloud: <https://console.cloud.google.com/marketplace/product/wikipedia-cdmw/wikipedia-pageview> | TimesFM (Google), Chronos (部分) | 2007至今（持续更新） |
| 9 | **UEA/UEA Time Series Classification** | 中高 -- 涵盖 30+ 多变量时序数据集；InceptionTime 等早期深度学习 TS 工作发起的基准；在 TSFM 评估中常被引用 | 完全开放 | UEA Archive: <http://www.timeseriesclassification.com/> | （主要用于评估） | 2019（最后一版更新） |
| 10 | **TSCut / Kaggle 行业数据集集合** | 中 -- 多个 Kaggle 竞赛数据（零售销售、交通流量、能源负荷等）；Chronos 预训练数据来源之一；实际使用需自行整理 | 部分开放 | Kaggle: <https://www.kaggle.com/datasets> （搜索 "time series forecasting"） | Chronos（部分数据来源） | 不等（各数据集独立） |
| 11 | **WeatherBench** | 中高 -- 气象基准数据集；用于天气预测模型评估；ERA5 子集整理；比直接用 ERA5 更易用；被多个天气预报模型引用 | 完全开放 | GitHub: <https://github.com/pangeo-data/WeatherBench> 或 Zenodo DOI | （主要用于评估，TSFM 零样本天气预测评测） | 2020（首发）/ 持续更新 |
| 12 | **PEMS Data (Caltrans)** | 中 -- 加州高速公路传感器数据（PEMS04/07/08）；多变量交通流量；被 PatchTST 等用于多变量预测实验 | 完全开放 | PEMS website: <https://pems.dot.ca.gov/> 或 GitHub 整理版 | （主要用于评估和监督训练） | 持续更新 |

---

## 重点数据集详细说明

### 1. UTSD / TimeBench (当前规模最大的 TSFM 训练语料)

| 属性 | 说明 |
|------|------|
| **规模** | 约 **1 万亿 (1 Trillion) 时间点**；UTSD 提供 4 种配置: UTSD-1G (~1GB), UTSD-2G, UTSD-4G, UTSD-12G |
| **构成** | 主要为真实世界数据集 + 合成数据；其中 ERA5 气象数据占约 **84.66%** |
| **领域覆盖** | 8 大领域: Nature, Health, Web, ERA5, Energy, Transport, IoT, Environment |
| **频率覆盖** | 高频（分钟级）到低频（年频）的多频率时序 |
| **HuggingFace** | <https://huggingface.co/datasets/thuml/UTSD> (configs: UTSD-1G/2G/4G/12G) |
| **GitHub** | <https://github.com/thuml/TimeBench> |
| **论文引用** | Sundial (arXiv:2502.00816), Timer-S1 (arXiv:2603.04791) |
| **局限** | 数据偏向气象领域，信号结构多样性主要依赖"领域x频率"笛卡尔积，未基于信号特征设计 |

### 2. ERA5 Reanalysis Data (TSFM 训练数据基石)

| 属性 | 说明 |
|------|------|
| **规模** | 每小时约 800GB（完整覆盖 1950-现在）；TimeBench 中约 8000 亿时间点 |
| **内容** | 全球气象再分析数据：温度、湿度、风速、气压等 |
| **开放程度** | 完全开放，通过 CDS API 下载 |
| **官方获取** | <https://cds.climate.copernicus.eu/> |
| **AWS 镜像** | <https://registry.opendata.aws/ecmwf-era5/> |
| **局限** | 高度领域集中（仅气象），气象数据信号特征（强季节性、平滑性）无法覆盖高噪声/非平稳金融时序 |

### 3. Chronos 预训练数据集

| 属性 | 说明 |
|------|------|
| **来源** | 公开数据集（Kaggle、UCI、Monash Archive 等数十个来源）+ Gaussian Process 合成数据 |
| **数据集数量** | 67 个子集 (HuggingFace configs)，涵盖多领域 |
| **合成增强** | TSMixup + KernelSynth 生成多样化合成序列 |
| **HuggingFace** | <https://huggingface.co/datasets/autogluon/chronos_datasets> (67 configs) |
| **GitHub** | <https://github.com/amazon-research/chronos> |
| **论文引用** | Ansari et al., ICLR 2024 |
| **注意** | 原 `Amazon-SF/chronos-preprocessed-data` 已迁移至 `autogluon/chronos_datasets`，数据结构从单一 `target` 列变为 `id` + `timestamp` + `target` 三列格式 |

### 4. TimesFM 预训练语料

| 属性 | 说明 |
|------|------|
| **主体** | Wikipedia Pageviews（约 95%）+ 其他公开数据 |
| **特点** | 数据规模大但领域集中度高 |
| **开源地址** | <https://github.com/google-research/timesfm> |
| **论文引用** | Das et al., ICML 2024 |
| **局限** | 严重偏向互联网页面访问领域（约 95% Wiki Pageviews），信号结构多样性不足 |

### 5. Monash Time Series Archive

| 属性 | 说明 |
|------|------|
| **规模** | 30+ 主流时序数据集统一格式化整理，约 577MB |
| **领域** | 能源、交通、医疗、金融、零售等 |
| **HuggingFace** | <https://huggingface.co/datasets/Monash-University/monash_tsf> (30+ configs) |
| **官网** | <https://forecastingdata.org/> |
| **论文引用** | Godahewa et al., ECUE 2022 |
| **使用方式** | PatchTST 等监督模型用于训练；TSFM 零样本评估基准 |
| **注意** | 原 GitHub 仓库 `rakibhoity/monash_ts_archive` 已不可用 (404)；现通过 HuggingFace `Monash-University/monash_tsf` 获取，支持 `load_dataset("Monash-University/monash_tsf", "<subset>")` 流式加载 |

### 6. ETT (Electricity Transformer Temperature)

| 属性 | 说明 |
|------|------|
| **规模** | 4 个子集: ETTh1, ETTh2, ETTm1, ETTm2；每子集 7 条超长序列 (10k-70k 点) |
| **特点** | 超长少轨迹类型，不适合分布层面的结构分析 |
| **GitHub** | <https://github.com/zhouhaoyi/ETDataset> |
| **论文引用** | Zhou et al., IJCAI 2021 (Informer) |
| **TS3 状态** | 已标记为 DEPRECATED，默认跳过 |

---

## 关键发现

1. **UTSD/TimeBench + ERA5 是当前最核心的 TSFM 训练语料**，Sundial 和 Timer-S1 均依赖此数据集，ERA5 单数据集占 TimeBench 约 84.66%。

2. **数据领域集中度极高**：TimesFM 的 Wiki Pageviews 约 95%，ERA5 气象数据 84.66%，导致现有 TSFM 对金融、医疗等非气象/互联网时序的泛化能力存疑。

3. **数据多样性问题**：现有数据配比策略全部基于"业务领域 x 采样频率"设计，缺少基于**信号数学特征**（平稳性、谱熵、趋势复杂度、非平稳性等）的多样化采样策略。

4. **完全开源的数据集**：UTSD/TimeBench、ERA5、Chronos、Monash Archive 均可自由获取；M4/M5 需要同意竞赛协议；PEMS 等部分需要申请。

5. **评估基准 vs 训练数据**：M4/M5、UEA、Monash Archive 主要用于**模型评估**，而非训练；真正用于预训练的大规模数据主要是 TimeBench、ERA5、Wikipedia Pageviews。

6. **数据源迁移**（2026-06 更新）：
   - Monash Archive 原 GitHub 仓库 (`rakibhoity/monash_ts_archive`) 已不可用，迁移至 HuggingFace (`Monash-University/monash_tsf`)
   - Chronos 预训练数据从 `Amazon-SF/chronos-preprocessed-data` 迁移至 `autogluon/chronos_datasets`，数据结构从单列 `target` 变为 `id` + `timestamp` + `target` 三列格式
   - TimeBench 在 HuggingFace 上以 `thuml/UTSD` 发布，提供 UTSD-1G/2G/4G/12G 四种配置

---

## 参考论文

| 论文 | 年份 | 引用 |
|------|------|------|
| Sundial: A Family of Highly Capable Time Series Foundation Models (arXiv:2502.00816) | 2025 | Liu et al., THUMLab |
| Timer-S1: A Billion-Scale Time Series Foundation Model with Serial Scaling (arXiv:2603.04791) | 2026 | Liu et al., THUMLab + ByteDance |
| Chronos: Learning the Language of Time Series (arXiv:2403.07815) | 2024 | Ansari et al., AWS AI Labs (ICLR 2024) |
| TimesFM: Time Series Foundation Model with Pretraining on Wikipedia Pageviews | 2024 | Das et al., Google Research (ICML 2024) |
| It's TIME: Towards the Next Generation of Time Series Forecasting Benchmarks (arXiv:2602.12147) | 2026 | Qiao et al. |
| Are Transformers Effective for Time Series Forecasting? (arXiv:2205.13504) | 2022 | Zeng et al., LTSF-Linear |

---

*Updated: 2026-06-12*