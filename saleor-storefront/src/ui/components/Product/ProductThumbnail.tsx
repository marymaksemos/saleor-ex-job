"use client";
import * as React from "react";
import * as RadioGroupPrimitive from "@radix-ui/react-radio-group";
import { cn } from "@/lib/utils";

const ThumbnailWrapper = React.forwardRef<
	React.ElementRef<typeof RadioGroupPrimitive.Root>,
	React.ComponentPropsWithoutRef<typeof RadioGroupPrimitive.Root>
>(({ className, ...props }, ref) => {
	return (
		<RadioGroupPrimitive.Root
			className={cn("items-cneter flex justify-center gap-4", className)}
			{...props}
			ref={ref}
		/>
	);
});

ThumbnailWrapper.displayName = "ThumbnailWrapper";

const ThumbnailItem = React.forwardRef<
	React.ElementRef<typeof RadioGroupPrimitive.Item>,
	React.ComponentPropsWithoutRef<typeof RadioGroupPrimitive.Item>
>(({ className, ...props }, ref) => {
	return (
		<RadioGroupPrimitive.Item
			ref={ref}
			className={cn(
				"h-24 w-24 cursor-pointer overflow-hidden rounded-md border border-blue-200 bg-blue-50 outline-none focus:border-blue-500 data-[state=checked]:border-blue-500",
				className,
			)}
			{...props}
		></RadioGroupPrimitive.Item>
	);
});

ThumbnailItem.displayName = "ThumbnailItem";

export { ThumbnailWrapper, ThumbnailItem };
