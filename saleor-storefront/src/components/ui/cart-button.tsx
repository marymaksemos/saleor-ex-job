import * as React from "react";
import { Slot } from "@radix-ui/react-slot";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";

const cartButtonVariants = cva(
	"capitalize focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring focus-visible:ring-offset-0 disabled:pointer-events-none disabled:opacity-50",
	{
		variants: {
			variant: {
				white: "bg-white text-gray-700",
				primary: "bg-yellow-400 text-gray-800",
			},
			size: {
				default: "px-12 py-2.5",
			},
			rounded: {
				md: "rounded-md",
			},
		},
		defaultVariants: {
			variant: "primary",
			size: "default",
			rounded: "md",
		},
	},
);

export interface ButtonProps
	extends React.ButtonHTMLAttributes<HTMLButtonElement>,
		VariantProps<typeof cartButtonVariants> {
	asChild?: boolean;
}

const CartButton = React.forwardRef<HTMLButtonElement, ButtonProps>(
	({ className, variant, size, asChild = false, ...props }, ref) => {
		const Comp = asChild ? Slot : "button";

		return <Comp ref={ref} {...props} className={cn(cartButtonVariants({ variant, size, className }))} />;
	},
);
CartButton.displayName = "CartButton";

export { CartButton, cartButtonVariants };
