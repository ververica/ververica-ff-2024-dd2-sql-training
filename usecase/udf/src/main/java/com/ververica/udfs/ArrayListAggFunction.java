package com.ververica.udfs;

import org.apache.flink.table.functions.AggregateFunction;

import java.util.ArrayList;
import java.util.List;

public class ArrayListAggFunction extends AggregateFunction<List<String>, List<String>> {
    public void accumulate(List<String> acc, String value) {
        if (value != null && !acc.contains(value)) {
            acc.add(value);
        }
    }

    @Override
    public List<String> getValue(List<String> acc) {
        return acc;
    }

    @Override
    public List<String> createAccumulator() {
        return new ArrayList<String>();
    }

    public void merge(List<String> acc, Iterable<List<String>> values) {
        for (List<String> vs : values) {
            for (String v: vs) {
                this.accumulate(acc, v);
            }
        }
    }
}
