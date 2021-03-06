package com.lwj.sell.service;


import com.lwj.sell.dto.OrderDTO;

/**
 * 推送消息
 * Created by lwj

 */
public interface PushMessageService {

    /**
     * 订单状态变更消息
     *
     * @param orderDTO
     */
    void orderStatus(OrderDTO orderDTO);
}
