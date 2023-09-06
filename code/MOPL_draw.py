# -*- coding: utf-8 -*-
# @Author  : Xiang Yu (yuxiang@bit.edu.cn; albertmilagro@gmail.com)
# @Time    : 2023/9/6 15:18
# @File    : MOPL_draw.py

import os
import matplotlib.pyplot as plt
import numpy as np
# plt.style.use('bmh')
def draw_raw_points(data_path):
    length_list = []  # word length
    repeat_list = []  # frequency
    jump_head_flag = 1
    for line in open(data_path):
        # jump headline
        if jump_head_flag:
            jump_head_flag = 0
            continue
        #
        length_list.append(int(line.strip().split('\t')[0]))
        repeat_list.append(int(line.strip().split('\t')[2]))
        n = sum(repeat_list)
    repeat_percentage_list = [count / n for count in repeat_list]  # raw data count percentage
    parameters = data_path.split('/')[-1].split('.')[0] + ' ($n=' + str(n) + '$)'%()
    plt.plot(length_list, repeat_percentage_list, "o", label=parameters)


def draw(raw_dir, moe_trunc_data_path, draw_dir):
    plt.figure(figsize=(5.5, 4.5))
    # draw raw data
    draw_raw_points(raw_dir)
    length_list = []  # word length
    fit_list = []
    jump_head_flag = 1
    for line in open(moe_trunc_data_path):
        # jump headline
        if jump_head_flag:
            jump_head_flag = 0
            continue
        #
        length_list.append(int(line.strip().split('\t')[0]))
        fit_list.append(int(float(line.strip().split('\t')[2])))
        n_fit = sum(fit_list)
    fit_percentage_list = [count/n_fit for count in fit_list]  # predict data count percentage
    # filter fit=0
    i = 0
    for i in range(0, len(fit_percentage_list)):
        if fit_percentage_list[i] == 0 :
            length_list = length_list[0:i]
            fit_percentage_list = fit_percentage_list[0:i]
            break

    # calculate raw data size and coverage
    raw_repeat_list = []
    jump_head_flag = 1
    for line in open(raw_dir):
        # jump headline
        if jump_head_flag:
            jump_head_flag = 0
            continue
        #
        raw_repeat_list.append(int(line.strip().split('\t')[2]))
        n = sum(raw_repeat_list)

    plt.plot(length_list, fit_percentage_list, "*-", label="MOPL", color="red", linewidth=2, zorder=4)

    plt.legend(loc='lower left', frameon=False, numpoints=1)

    plt.xscale('log')
    plt.yscale('log')
    # plt.ylim(top=1)
    a = draw_dir + '/' + raw_dir.split('/')[-1].split('.')[0]
    plt.savefig(draw_dir + '/' + raw_dir.split('/')[-1].split('.')[0]+'.png', pad_inches=0.05, bbox_inches='tight', dpi=300)
    plt.show()
    print(draw_dir + '/' + raw_dir.split('/')[-1].split('.')[0])


if __name__ == '__main__':

    #--------different types---------#
    raw_dir = '../data/different_types'   # raw data
    moe_trunc_dir = '../result/different_types'   # MOPL truncated
    draw_dir = '../image/different_types'  # draw

    # # #----different languages--------#
    # raw_dir = '../data/different_languages'  # raw data
    # moe_trunc_dir = '../result/different_languages'  # MOPL truncated
    # draw_dir = '../image/differnet_languages'  # draw


    raw_list = [f for f in os.listdir(raw_dir) if f.find('txt') != -1]
    raw_list.sort()
    moe_trunc_list = [f for f in os.listdir(moe_trunc_dir) if f.find('txt') != -1]
    moe_trunc_list.sort()

    for i in range(0, len(moe_trunc_list)):
        raw_data_path = raw_dir + '/' + raw_list[i]
        moe_trunc_data_path = moe_trunc_dir + '/' + moe_trunc_list[i]
        print(raw_data_path, moe_trunc_data_path)
        draw(raw_data_path, moe_trunc_data_path, draw_dir)
