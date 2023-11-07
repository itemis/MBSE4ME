package com.itemis.mbse4me.dsls.utils;

public class StringUtils {

	public static String getPieceOrPieces(int count) {
		StringBuilder sb = new StringBuilder();
		sb.append(count);
		sb.append(" piece");
		if (count > 1) {
			sb.append("s");
		}
		return sb.toString();
	}
}
