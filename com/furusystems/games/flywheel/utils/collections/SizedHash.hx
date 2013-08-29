package com.furusystems.utils;

/**
 * ...
 * @author Andreas Rønning
 */

class SizedHash<T> extends Hash<T> {
  public var size(default, null): Int;

  public function new() { super(); size = 0; }

  public override function set(key: String, val:T) : Void {
    if (! exists(key)) size++;
    super.set(key, val);
  }

  public override function remove(key) : Bool {
    if (exists(key)) size--;
    return super.remove(key);
  }
}