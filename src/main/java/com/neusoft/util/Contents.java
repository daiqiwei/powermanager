package com.neusoft.util;

/**将属性和数据库字段置为一样 加上"_"
 *
 */
public class Contents {
    public static String to_col(String pro)
    {
        char[] chars=pro.toCharArray();
        int index=0;
        for(int i=0;i<chars.length;i++)
        {
            if(chars[i]>='A'&&chars[i]<='Z')
            {
                index=i;
                break;
            }
        }
      return   pro.substring(0,index)+"_"+pro.substring(index);
    }
}
