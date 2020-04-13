package com.lwj.sell.service;

import com.lly835.bestpay.model.PayResponse;
import com.lly835.bestpay.model.RefundResponse;
import com.lwj.sell.dto.OrderDTO;

/**
 * 支付
 * Created by lwj
 * 2020-04-10 00:53
 */
public interface PayService {

    PayResponse create(OrderDTO orderDTO);

    PayResponse notify(String notifyData);

    RefundResponse refund(OrderDTO orderDTO);
}
