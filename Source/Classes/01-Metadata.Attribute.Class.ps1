Add-Type @'
using System;
using System.Collections.Generic;
public class MetadataAttribute : Attribute
{
  private string[] _tags;

  public MetadataAttribute(params string[] tags) {
    _tags = tags;
  }

  public IEnumerable<string> GetTags() {
    foreach(var tag in _tags) yield return tag;
  }
}
'@