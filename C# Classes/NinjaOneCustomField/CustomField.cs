using System.Collections.Generic;
namespace NinjaOne {
    public class CustomField {
        public string name;
        public object value;
        public bool isHtml;
        public CustomField(string name, object value, bool isHtml = false) {
            if (isHtml) {
                this.name = name;
                this.value = new Dictionary<string, object> { { "html", value } };
            } else {
                this.name = name;
                this.value = value;
            }
        }
    }
}
