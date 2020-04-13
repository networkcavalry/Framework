package com.lwj.sell.exception;

import com.lwj.sell.enums.ResultEnum;
import lombok.Getter;

/**
 * Created by lwj
 * 2020-04-10 18:55
 */
@Getter
public class SellException extends RuntimeException {

    private Integer code;

    public SellException(ResultEnum resultEnum) {
        super(resultEnum.getMessage());
        this.code = resultEnum.getCode();
    }

    public SellException(Integer code, String message) {
        super(message);
        this.code = code;
    }
}
