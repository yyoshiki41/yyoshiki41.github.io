---
layout: post
title: Particle Swarm Optimization v.2
---

<a href="./../pso/">1回目のPSOの記事はこちら</a>

上の記事の式でも問題ないのですが、より厳密な更新式にならって書き直します。

<a href="https://github.com/yyoshiki41/Particle_Swarm_Optimization">GitHub</a>にも公開しております。(File名:<em>pso-exaple.cpp</em>)

&nbsp;

### 変更点
pbest項とgbest項に共通だった係数cを、別々にかかるようにしました。

尚、c1,c2にはそれぞれパラメータ推奨値
<em>c1=1.494, c2=1.494</em>
を用いています。

#### Before

{% highlight cpp linenos %}
v[i][n] = λ * v[i][n] + r1 * (x_pbest[i][n] - x[i][n]) + r2 * (x_gbest[n] - x[i][n]);
x[i][n] = x[i][n] + c * v[i][n];
{% endhighlight %}

#### after

{% highlight cpp linenos %}
v[i][n] = λ * v[i][n] + c1 * r1 * (x_pbest[i][n] - x[i][n]) + c2 * r2 * (x_gbest[n] - x[i][n]);
x[i][n] = x[i][n] + v[i][n];
{% endhighlight %}

&nbsp;

### 結果
[![]({{ site.url }}/img/posts/pso/pso-revised.png)]({{ site.url }}/img/posts/pso/pso-revised.png)

### コード

{% highlight cpp linenos %}
#include <iostream>
#include <fstream>
#include <math.h>

#define N 2  // 次元
#define I 5  // 初期点数
#define K 30 // イテレーション数
#define v_max 1 // 最大の移動量

using namespace std;

double __2n_minima (double *x);

int main()
{
	// file出力の為の定義
	ofstream fout;
	fout.open("pso/pso-example.txt");
	// 見出し
	fout << "k\tx1_1\tx1_2\tx2_1\tx2_2\tx3_1\tx3_2\tx4_1\tx4_2\tx5_1\tx5_2" << endl;

	// 初期点郡
	double x[I][N] = {
		{-4, 0},
		{-1, 3},
		{0, -2},
		{-4, -3},
		{3, -1},
	};
	// 各点での関数値とBest値
	double f_temp, f_pbest[I], f_gbest;
	// 各点の実際の値
	double x_pbest[I][N], x_gbest[N];
	// 移動量
	double v[I][N];

	// イテレーション0回目の設定
	fout << 0 << "\t";
	for (int i = 0; i < I; i++) {
		f_temp = __2n_minima(x[i]);
		f_pbest[i] = f_temp;
		for (int n = 0; n < N; n++) {
			x_pbest[i][n] = x[i][n];
			v[i][n] = 0;
			fout << x[i][n] << "\t";
		}
		if (i == 0 || f_gbest > f_temp) {
			f_gbest = f_temp;
			for (int n = 0; n < N; n++) {
				x_gbest[n] = x[i][n];
			}
		}
	}
	fout << endl;

	// 各パラメータ
	double λ, r1, r2;
	double λ_max = 1.0, λ_min = 0.6;
	double c1 = 1.494, c2 = 1.494;

	for(int k = 1; k <= K; k++) {
		// Inertia Weight Approach
		λ = λ_max - (λ_max - λ_min) * k / K;

		// グループ内のBestを計算
		for (int i = 0; i < I; i++) {
			f_temp = __2n_minima(x[i]);
			if (f_pbest[i] > f_temp) {
				for (int n = 0; n < N; n++) {
					x_pbest[i][n] = x[i][n];
				}
				f_pbest[i] = f_temp;
				if (f_gbest > f_temp) {
					f_gbest = f_temp;
					for (int n = 0; n < N; n++) {
						x_gbest[n] = x[i][n];
					}
				}
			}
		}

		fout << k << "\t";
		// イテレーション毎のgbest を用いるため、for 文は分ける
		for (int i = 0; i < I; i++) {
			r1 = ((double)rand() / ((double)RAND_MAX + 1)) * 1.0;
			r2 = ((double)rand() / ((double)RAND_MAX + 1)) * 1.0;
			for (int n = 0; n < N; n++) {
				v[i][n] = λ * v[i][n] + c1 * r1 * (x_pbest[i][n] - x[i][n]) + c2 * r2 * (x_gbest[n] - x[i][n]);
				// 発散を防ぐ
				if (v[i][n] < -1 * v_max) {
					v[i][n] = -1 * v_max;
				} else if (v[i][n] > v_max) {
					v[i][n] = v_max;
				}

				x[i][n] = x[i][n] + v[i][n];
				fout << x[i][n] << "\t";
			}
		}
		fout << endl;
	}
}

/*
 * 目的関数 2N-minima 関数
 */
double __2n_minima (double x[N])
{
	double f;
	f = pow(x[0], 4) - 16 * pow(x[0], 2) + 5 * x[0] + pow(x[1], 4) - 16 * pow(x[1], 2) + 5 * x[1];
	return f;
}
{% endhighlight %}
